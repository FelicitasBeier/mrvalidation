#' @title calcValidPriceLand
#' @description Validates MAgPIE (crop) Land prices
#' @param datasource FAO_USDA
#'
#' @author Edna J. Molina Bacca
#' @examples
#' \dontrun{
#' calcOutput("ValidPriceLand")
#' }
#'
calcValidPriceLand <- function(datasource = "FAO_USDA") {

  if (datasource == "FAO_USDA") {
    # read the prices from mrfactors
    out <- calcOutput("LandRent", aggregate = FALSE)
    getNames(out) <- "Prices|Land|Cropland (US$2017/ha)"


    # Weight
    weight <- dimSums(calcOutput("LanduseInitialisation", nclasses = "seven", aggregate = FALSE,
                                 cellular = FALSE)[, , c("crop")], dim = 3)[, getYears(out), ]
    getNames(weight) <- getNames(out)
    weight[out == 0] <- 10^-10

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)


  } else {
    stop("unknown data source")
  }

  return(list(x = out,
              weight = weight,
              unit = "US$2017/ha",
              description = "Price of cropland per hectare, based on FAO's VoP data and USDA's input shares",
              isocountries = TRUE))
}
