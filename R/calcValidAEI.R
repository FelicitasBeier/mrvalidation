#' @title calcValidAEI
#'
#' @description Returns historical area equipped for irrigation.
#'
#' @param datasource Currently available: \code{"LUH3"}, \code{"HID"}, \code{"GMIA"}, and \code{"Mehta2022"}
#' @return list of magpie object with data and weight
#' @author Stephen Wirth, Anne Biewald, Felicitas Beier
#' @importFrom magpiesets reportingnames
#' @importFrom magclass collapseNames

calcValidAEI <- function(datasource = "LUH3") {

  if (datasource %in% c("LUH3", "Mehta2024_Siebert2013", "Mehta2024_Meier2018")) {
    out <- collapseNames(calcOutput("AreaEquippedForIrrigation",
                                    cellular = FALSE, aggregate = FALSE)[, , datasource])
  } else if (datasource == "HID") {
    out <- readSource("HID", "national_1900_2005") / 10^6
  } else if (datasource == "GMIA") {
    out <- calcOutput("GMIA", aggregate = FALSE)[, , "AEI_ha_"] / 10^6
  } else {
    stop("Given datasource currently not supported!")
  }

  out <- collapseDim(out, dim = 3)
  out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
  out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
  out <- add_dimension(out, dim = 3.3, add = "variable",
                       nm = "Resources|Land Cover|Cropland|Area equipped for irrigation (million ha)")

  return(list(x = out,
              weight = NULL,
              unit = "million ha",
              min = 0,
              description = "Area equipped for Irrigation in Mha"))
}
