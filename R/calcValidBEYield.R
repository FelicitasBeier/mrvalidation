#' @title calcValidBEYield
#' @description Validation dataset for bioenergy crop yields from Li et al. (2020).
#' Each of the five crop types is returned as an independent entry at country ISO level.
#'
#' @return List of magpie objects with results on country level, weight, unit, min, max, description.
#' @author Kristine Karstens
#' @seealso [mrcommons::calcBEYield()]
#' @examples
#' \dontrun{
#' calcOutput("ValidBEYield")
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

  # Aggregate each crop independently to country level weighted by 1995 cropland area
  weight  <- calcOutput("Croparea", sectoral = "kcr", physical = TRUE,
                        cellular = TRUE, aggregate = FALSE)
  weight  <- setYears(dimSums(weight[, "y1995", ], dim = 3), "y1995")
  weight  <- time_interpolate(weight, years, extrapolation_type = "constant",
                              integrate_interpolated_years = TRUE)
  mapping <- toolGetMappingCoord2Country()
  mapping$coordiso <- paste(mapping$coords, mapping$iso, sep = ".")

  out <- NULL
  for (crop in names(crops)) {
    layer <- setNames(x[, , crop], paste0("Productivity|Yield|", crops[crop], " (t DM/ha)"))
    weightCrop <- weight
    weightCrop[is.na(layer)] <- 0
    layer[is.na(layer)] <- 0
    layer <- toolAggregate(layer, rel = mapping, weight = weightCrop,
                           from = "coordiso", to = "iso", dim = 1)
    layer <- toolCountryFill(layer, fill = NA)
    layer <- add_dimension(layer, dim = 3.1, add = "scenario", nm = "historical")
    layer <- add_dimension(layer, dim = 3.2, add = "model",    nm = paste0("Li2020-", crop))
    out   <- mbind(out, layer)
  }

  names(dimnames(out))[3] <- "scenario.model.variable"

  # Country-level cropland area as weight
  weightIso <- toolAggregate(weight, rel = mapping, from = "coordiso", to = "iso", dim = 1)
  weightIso <- toolCountryFill(weightIso, fill = 0)
  weightIso <- setNames(weightIso, NULL)

  # Expand weight to match all data dimensions of out; zero where out is NA
  # so those countries are excluded from country-to-region aggregation
  weightOut <- out * 0 + weightIso
  weightOut[is.na(weightOut)] <- 0
  weightOut[is.na(out)] <- 0
  out[is.na(out)] <- 0

  return(list(x           = out,
              weight      = weightOut,
              unit        = "t DM/ha",
              min         = 0,
              max         = 100,
              description = "Bioenergy crop yields from Li et al. (2020), doi:10.5194/essd-12-789-2020"))
}
