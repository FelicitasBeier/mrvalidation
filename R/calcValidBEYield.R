#' @title calcValidBEYield
#' @description Validation dataset for bioenergy crop yields from Li et al. (2020).
#' Each of the five crop types is returned as an independent entry at cellular level.
#'
#' @param cellular determines whether data is returned at grid cell level
#'                 For aggregate = FALSE, cellular should be set to TRUE
#'                 For aggregate = "region+global", cellular should be set to FALSE
#'                 such that iso countries can be returned. Default is FALSE.
#'
#' @return List of magpie objects with results on cellular level, weight, unit, min, max, description.
#' @author Kristine Karstens, Felicitas Beier, Patrick Rein
#' @seealso [mrcommons::calcBEYield()]
#' @examples
#' \dontrun{
#' calcOutput("ValidBEYield", aggregate = FALSE)
#' }
calcValidBEYield <- function(cellular = FALSE) {

  crops <- c(Eucalypt    = "Bioenergy crops|Short rotation trees",
             Poplar      = "Bioenergy crops|Short rotation trees",
             Willow      = "Bioenergy crops|Short rotation trees",
             Miscanthus  = "Bioenergy crops|Short rotation grasses",
             Switchgrass = "Bioenergy crops|Short rotation grasses")

  x      <- readSource("Li2020", convert = FALSE)
  years  <- paste0("y", seq(1995, 2010, by = 5))
  x      <- time_interpolate(x, years, extrapolation_type = "constant",
                             integrate_interpolated_years = TRUE)

  # Cropland area (summed over all crops, 1995 base year) used as aggregation weight.
  weight <- calcOutput("Croparea", sectoral = "kcr", physical = TRUE,
                       cellular = TRUE, aggregate = FALSE)
  weight <- setYears(dimSums(weight[, "y1995", ], dim = 3), NULL)

  out <- NULL
  for (crop in names(crops)) {
    layer <- setNames(x[, , crop], paste0("Productivity|Yield|", crops[crop], " (t DM/ha)"))
    layer <- add_dimension(layer, dim = 3.1, add = "scenario", nm = "historical")
    layer <- add_dimension(layer, dim = 3.2, add = "model",    nm = paste0("Li2020-", crop))
    out   <- mbind(out, layer)
  }

  names(dimnames(out))[3] <- "scenario.model.variable"

  # Crop-specific weights: cells with NA yield are set to 0 so they are
  # excluded from weighted aggregation and flagged via zeroWeight = "setNA".
  weightOut <- out * 0 + weight
  weightOut[is.na(weightOut)] <- 0
  weightOut[is.na(out)] <- 0
  out[is.na(out)] <- 0

  # aggregate to iso countries for aggregation to regional resolution
  if (!cellular) {
    out <- toolAggregate(out, weight = weightOut, to = "iso", zeroWeight = "allow")
    out <- toolCountryFill(out, fill = 0)
    weightOut <- toolAggregate(weightOut, weight = NULL, to = "iso")
    weightOut <- toolCountryFill(weightOut, fill = 0)
  }

  return(list(x            = out,
              weight       = weightOut,
              unit         = "t DM/ha",
              min          = 0,
              max          = 100,
              isocountries = TRUE,
              description  = "Bioenergy crop yields from Li et al. (2020), doi:10.5194/essd-12-789-2020"))
}
