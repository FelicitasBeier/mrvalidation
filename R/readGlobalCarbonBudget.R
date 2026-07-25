#' @title readGlobalCarbonBudget
#' @description read the Global Carbon Budget, selecting the models GCB, BLUE, H&C2023, OSCAR and their sub-components
#' Net, Deforestation, Forest regrowth, Other transitions, Wood harvest and other forest management
#'
#' @author Michael Crawford
#'
#' @return a magpie object in Mt CO2 per year
#'
#' @examples
#' \dontrun{
#' readSource("GlobalCarbonBudget")
#' }
#' @importFrom dplyr %>%
#' @importFrom rlang .data

readGlobalCarbonBudget <- function() {

  # -----------------------------------------------------------------------------------------------------------------
  # Emissions from Land-use Change
  # Row 37 (skip = 36) holds the model names; row 38 (the first data row) holds the component
  # sub-labels; the numeric series start on row 39.
  eluc <- suppressMessages(readxl::read_excel("GCB.xlsx", sheet = "Land-Use Change Emissions", skip = 36))

  # The bookkeeping models do NOT share an identical column layout: GCB uniquely carries a
  # "peat drainage & peat fires" column between "other transitions" and "wood harvest". A fixed
  # column offset therefore silently mis-reads GCB's peat as its wood harvest (Timber) and drops
  # GCB's actual wood harvest. Select each component by its row-38 sub-label instead, so the layout
  # difference is handled robustly (GCB's peat column is simply not among the components read here).
  subLabels <- tolower(as.character(unlist(eluc[1, ])))

  componentMap <- c(
    "Emissions|CO2|Land|+|Land-use Change"                       = "net",
    "Emissions|CO2|Land|Land-use Change|+|Deforestation"         = "deforestation",    # incl. shifting cultivation
    "Emissions|CO2|Land|Land-use Change|+|Regrowth"              = "forest regrowth",
    "Emissions|CO2|Land|Land-use Change|+|Other land conversion" = "other transitions", # incongruent definitions
    "Emissions|CO2|Land|Land-use Change|+|Timber"                = "wood harvest"
  )

  yearData <- eluc %>%
    dplyr::select(.data$Year) %>%
    dplyr::slice(-1)

  elucOut <- NULL
  modelNames <- c("GCB", "BLUE", "H&C2023", "OSCAR")
  modelCols  <- match(modelNames, names(eluc))
  for (m in seq_along(modelNames)) {
    startCol <- modelCols[m]
    # a model's columns run up to the next model's; for the last model cap at a 6-column block width
    endCol   <- if (m < length(modelNames)) modelCols[m + 1] - 1 else min(startCol + 6, ncol(eluc))
    block    <- startCol:endCol

    selectedCols <- vapply(componentMap, function(lbl) {
      hit <- block[grepl(lbl, subLabels[block], fixed = TRUE)]
      if (length(hit) == 0) NA_integer_ else hit[1]
    }, integer(1))
    if (anyNA(selectedCols)) {
      stop("readGlobalCarbonBudget: could not locate component column(s) [",
           paste(names(componentMap)[is.na(selectedCols)], collapse = ", "), "] for model ",
           modelNames[m], " - check the GCB.xlsx 'Land-Use Change Emissions' sheet layout.")
    }

    modelData <- eluc %>%
      dplyr::select(dplyr::all_of(unname(selectedCols))) %>%
      dplyr::slice(-1)

    names(modelData) <- names(componentMap)

    modelData <- dplyr::bind_cols(yearData, modelData) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

    modelOut <- magclass::as.magpie(modelData)
    modelOut <- magclass::add_dimension(modelOut, dim = 3.1, add = "model", nm = modelNames[m])

    elucOut <- magclass::mbind(elucOut, modelOut)
  }

  # -----------------------------------------------------------------------------------------------------------------
  # Indirect emissions from climate change
  sland <- suppressMessages(readxl::read_excel("GCB.xlsx", sheet = "Terrestrial Sink", skip = 27)) %>%
    select(.data$Year, .data$GCB) %>%
    rename(`Emissions|CO2|Land|+|Indirect` = .data$GCB) %>%
    mutate(`Emissions|CO2|Land|+|Indirect` = .data$`Emissions|CO2|Land|+|Indirect` * -1) # as negative emissions

  slandOut <- magclass::as.magpie(sland)
  slandOut <- magclass::add_dimension(slandOut, dim = 3.1, add = "model", nm = "GCB")

  # -----------------------------------------------------------------------------------------------------------------
  # Net land flux
  gcbEluc <- elucOut[, , "GCB"][, , "Emissions|CO2|Land|+|Land-use Change"]
  gcbSland <- slandOut[, , "GCB"][, , "Emissions|CO2|Land|+|Indirect"]

  gcbNetLandFlux <- gcbEluc
  gcbNetLandFlux[, , ] <- 0
  gcbNetLandFlux[, , ] <- gcbEluc + gcbSland
  magclass::getNames(gcbNetLandFlux, dim = 2) <- "Emissions|CO2|Land"

  # -----------------------------------------------------------------------------------------------------------------
  # Combine output
  allOut <- magclass::mbind(gcbNetLandFlux, slandOut, elucOut)

  # select MAgPIE years
  years <- magclass::getYears(allOut, as.integer = TRUE)
  years <- years[years >= 1995]
  allOut <- allOut[, years, ]

  # convert from Gt C per year to Mt CO2 per year
  allOut <- allOut * (44 / 12) * 1e3

  return(allOut)
}
