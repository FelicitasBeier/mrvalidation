#' @title calcValidBII
#' @description Validation for the Biodiversity Intactness Index (BII) from one
#' NHM source, selected via \code{datasource}:
#'   * "Phillips" -- Phillips et al. 2021 (BII-BTE, DOI 10.5519/he1eqmg1),
#'     country-level 1970-2014.
#'   * "DePalma" -- De Palma et al. 2024 NHM v2.1.1 (DOI 10.5519/k33reyb6),
#'     cellular 5-yearly 2000-2020, aggregated to ISO here.
#'
#' De Palma et al. 2024 differs from Phillips et al. 2021 in three steps:
#' stricter primary-vegetation baseline (minimally/lightly-used primary only,
#' vs Phillips's all-primary including intensely-used sites), logit (not log)
#' transform, and balanced Bray-Curtis (abundance-weighted) compositional
#' similarity in place of Phillips's asymmetric Jaccard (species-identity only).
#' De Palma's absolute BII is markedly lower, with a non-uniform gap that
#' depends on land-use intensity, so the two series are NOT splice-compatible
#' and are kept as separate model labels.
#'
#' MAgPIE's own BII output (modules/44_biodiversity, coefficients from
#' Leclère et al. 2020 "Bending the Curve" via PREDICTS) is on the Phillips
#' scale, so it is close to Phillips et al. 2021 (~0.03 above) but sits markedly
#' above De Palma et al. 2024. For absolute-level validation use Phillips; for
#' harmonized (change-from-baseline) plots either series works, but mixing
#' MAgPIE projections with De Palma historical on a non-harmonized axis is
#' misleading. Two things drive the MAgPIE-vs-De Palma gap: the PREDICTS
#' coefficient version (Phillips vs De Palma), and land-use allocation -- MAgPIE
#' land use is LUH3-initialised with FAO/FRA forest correction
#' (mrlandcore::calcForestArea), vs the LUH2 underlying De Palma's v2.1.1. A 2010
#' decomposition shows the coefficient change dominates the gap (~0.17 of the
#' ~0.20 total globally, and larger than the land-use term in every H12 region);
#' the land-use/forest difference is real but secondary (~0.03 globally).
#' @author Michael Crawford, Florian Humpenoeder
#' @seealso \code{\link{readBII}}, \code{\link{downloadBII}}
#'
#' @param datasource "Phillips" (default) or "DePalma".
#'
#' @return Country-level MAgPIE object for the selected source under variable
#'   "Biodiversity|BII".
#'
#' @examples
#'
#' \dontrun{
#'    calcOutput("ValidBII", datasource = "Phillips")
#'    calcOutput("ValidBII", datasource = "DePalma")
#' }
#'
#' @importFrom madrat toolAggregate toolCountryFill toolNAreplace

calcValidBII <- function(datasource = "Phillips") {

  if (identical(datasource, "Phillips")) {
    # Phillips et al. 2021: already country-level.
    bii   <- readSource("BII", subtype = "Phillips", subset = "bii")
    bii   <- add_dimension(bii, dim = 3.2, add = "model", nm = "Phillips et al")
    descr <- "Historical BII, Phillips et al. 2021 (DOI 10.5519/he1eqmg1, 1970-2014)."

  } else if (identical(datasource, "DePalma")) {
    # De Palma et al. 2024 NHM v2.1.1: cellular -> ISO. toolNAreplace masks both
    # value and weight to 0 where either is NA, so toolAggregate's weighted mean
    # ignores water/missing cells instead of zeroing whole countries.
    biiCell  <- readSource("BII", subtype = "DePalma")
    cellArea <- calcOutput("LandArea", cells = "lpjcell", aggregate = FALSE)
    naFix    <- toolNAreplace(x = biiCell, weight = cellArea)
    bii      <- toolAggregate(naFix$x, weight = naFix$weight, to = "iso", dim = 1,
                              zeroWeight = "setNA")
    bii      <- toolCountryFill(bii, fill = NA, verbosity = 2)
    bii      <- add_dimension(bii, dim = 3.1, add = "scenario", nm = "historical")
    bii      <- add_dimension(bii, dim = 3.2, add = "model",    nm = "De Palma et al 2024")
    descr    <- paste("Historical BII, De Palma et al. 2024 v2.1.1",
                      "(DOI 10.5519/k33reyb6, 2000-2020), cellular aggregated to ISO.")

  } else {
    stop("Unknown datasource '", datasource, "'. Use \"Phillips\" or \"DePalma\".")
  }

  getNames(bii, dim = "variable") <- "Biodiversity|BII"

  land     <- calcOutput("FAOLand", aggregate = FALSE)
  landArea <- land[, "y2015", "6601|Land area"]   # land area stable across time

  return(list(x           = bii,
              weight      = landArea,
              unit        = "unitless",
              description = descr))
}
