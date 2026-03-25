#' @title calcValidBEYield
#' @description Validation dataset for bioenergy crop yields from Li et al. (2020).
#' Each of the five crop types is returned as an independent entry at cellular level.
#'
#' @return List of magpie objects with results on cellular level, weight, unit, min, max, description.
#' @author Kristine Karstens
#' @seealso [mrcommons::calcBEYield()]
#' @examples
#' \dontrun{
#' calcOutput("ValidBEYield", aggregate = FALSE)
#' }
calcValidBEYield <- function() {

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
  weight <- setYears(dimSums(weight[, "y1995", ], dim = 3), "y2010")

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

  return(list(x            = out,
              weight       = weightOut,
              unit         = "t DM/ha",
              min          = 0,
              max          = 100,
              isocountries = FALSE,
              description  = "Bioenergy crop yields from Li et al. (2020), doi:10.5194/essd-12-789-2020"))
}
