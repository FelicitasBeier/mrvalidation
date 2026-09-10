#' @title readGCBcountry
#' @description Read country-level bookkeeping land-use-change CO2 fluxes for the three GCB
#' bookkeeping models (BLUE, OSCAR, Houghton & Nassikas) from the Obermeier et al. (2024)
#' compilation. Net, gross source and gross sink are read for each model, 1950-2021, in Mt C
#' per year. The bookkeeping models do not represent peat, so the fluxes are native ex-peatland
#' (net = source + sink, no peat term).
#'
#' @return magpie object (ISO3 x year x model.component), Mt C/yr
#' @author Florian Humpenoeder
#' @seealso \code{\link[madrat]{readSource}}
#' @examples
#' \dontrun{
#' readSource("GCBcountry")
#' }

readGCBcountry <- function() {

  netFile   <- "Obermeier_2023_Country_level_Net_fluxes.xlsx"
  grossFile <- "Obermeier_2023_Country_level_Gross_fluxes.xlsx"
  models    <- c("BLUE22", "OSCAR22", "HN22")

  # country sheets only (drop README / CumStats / MeanStats summary sheets)
  isoSheets <- function(file) {
    sheets <- readxl::excel_sheets(file)
    sheets[grepl("^[A-Z]{3}$", sheets)]
  }

  # read one flux component (net / source / sink) for all three models across all country sheets
  readComponent <- function(file, column, component) {
    do.call(rbind, lapply(isoSheets(file), function(iso) {
      d <- as.data.frame(readxl::read_excel(file, sheet = iso, na = "#N/A"))
      do.call(rbind, lapply(models, function(m) {
        data.frame(region = iso, year = paste0("y", d$Year), model = m,
                   component = component, value = d[[column(m)]], stringsAsFactors = FALSE)
      }))
    }))
  }

  netDf    <- readComponent(netFile,   function(m) m,                    "net")
  sourceDf <- readComponent(grossFile, function(m) paste0(m, "_Source"), "source")
  sinkDf   <- readComponent(grossFile, function(m) paste0(m, "_Sink"),   "sink")

  # the net and gross files cover slightly different country sets, so unioning leaves structural NAs
  # (a country reported in only one file); left faithful here and set to 0 in correctGCBcountry
  as.magpie(rbind(netDf, sourceDf, sinkDf), spatial = "region", temporal = "year")
}
