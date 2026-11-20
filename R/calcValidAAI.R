#' @title calcValidAAI
#'
#' @description Returns historical area actually irrigated.
#'
#' @param datasource Currently available: \code{"LUH3"}, \code{"LUH2v2"}, \code{"GMIA"},
#'                   \code{"MAgPIEown"} (physical irrigated croparea of calcCroparea with its default
#'                   datasource, as used for MAgPIE initialisation), and
#'                   \code{"LandInG"} (physical irrigated croparea of calcCropareaLandInG, unscaled).
#'                   LandInG-based sources are returned for observed LandInG years only.
#' @return list of magpie object with data and weight
#' @author Stephen Wirth, Anne Biewald, Felicitas Beier
#' @importFrom magpiesets reportingnames
#' @importFrom madrat readSource calcOutput
#' @importFrom magclass dimSums add_dimension

calcValidAAI <- function(datasource = "LUH3") {

  if (datasource %in% c("LUH2v2", "LUH3")) {
    if (datasource == "LUH2v2") {
      out <- calcOutput("LUH2v2", landuse_types = "LUH2v2", irrigation = TRUE,
                        cellular = FALSE, selectyears = "past", aggregate = FALSE)
    } else if (datasource == "LUH3") {
      out <- calcOutput("LUH3", landuseTypes = "LUH3", irrigation = TRUE,
                        cellular = FALSE, aggregate = FALSE)
    }
    out <- collapseNames(out[, , c("c3ann", "c4ann", "c3per", "c4per", "c3nfx")][, , "irrigated"])
    out <- dimSums(out, dim = 3)
  } else if (datasource == "GMIA") {
    out <- calcOutput("GMIA", aggregate = FALSE)[, , "AAI_ha_"] / 10^6
  } else if (datasource %in% c("MAgPIEown", "LandInG")) {
    landing <- calcOutput("CropareaLandInG", sectoral = "kcr", physical = TRUE,
                          cellular = FALSE, irrigation = TRUE, aggregate = FALSE)
    if (datasource == "MAgPIEown") {
      out <- calcOutput("Croparea", sectoral = "kcr", physical = TRUE, fallow = FALSE,
                        cellular = FALSE, irrigation = TRUE, aggregate = FALSE)
      # calcCroparea holds the last LandInG year constant until 2020; keep observed years only
      out <- out[, intersect(getYears(out), getYears(landing)), ]
    } else {
      out <- landing
    }
    out <- dimSums(out[, , "irrigated"], dim = 3)
  } else {
    stop("Given datasource currently not supported!")
  }

  out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
  out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
  getNames(out, dim = 3)  <- paste("Resources|Land Cover|Cropland|Area actually irrigated",
                                   "(million ha)", sep = " ")
  names(dimnames(out))[3] <- "scenario.model.variable"

  return(list(x = out,
              weight = NULL,
              unit = "million ha",
              min = 0,
              description = "Area actually irrigated in Mha")
  )
}
