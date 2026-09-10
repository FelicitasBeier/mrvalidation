#' @title ValidGlobalCarbonBudget
#' @description validation for total and cumulative land emissions from the Global Carbon Budget, including
#' all bookkeeping models
#'
#' @details
#' The historical series pooled under \code{Emissions|CO2|Land|+|Land-use Change} are all LUC-scale CO2
#' SOURCES and are broadly comparable to MAgPIE's \code{+|Land-use Change}. Verified against the ingested
#' validation data (not the parent publications), they form a single positive cloud (Mt CO2/yr, World,
#' 2000-2010): bookkeeping BLUE/OSCAR/GCB/H&C ~2600-6600 and the national-statistics series
#' FAO_EmisLUC/EDGAR_LU/PRIMAPhist ~2800-5400 - the latter numerically indistinguishable from the
#' bookkeeping cloud. They differ mainly on PEAT; a second, conceptual axis (INDIRECT/Grassi) matters in
#' principle but is NOT represented in the ingested data (see Axis 2):
#' \tabular{lll}{
#'   \strong{source}      \tab \strong{peat} \tab \strong{nature (as ingested)}            \cr
#'   BLUE, OSCAR, H&C2023  \tab incl \tab net has GCB's peat folded in (see PEAT below)      \cr
#'   GCB (this fn)         \tab incl \tab published GCB net (own net column, peat folded in)\cr
#'   Gasser et al 2020     \tab excl \tab OSCAR bookkeeping (separate fn)                   \cr
#'   FAO_EmisLUC           \tab incl \tab FAOSTAT net LULUCF ("Land Use total"), a source   \cr
#'   EDGAR_LU              \tab incl \tab EDGAR LULUCF CO2, a source                        \cr
#'   PRIMAPhist            \tab incl \tab PRIMAP-hist CAT5 (LUCF) CO2, a source             \cr
#' }
#'
#' Axis 1 - PEAT. GCB folds a common peat drainage & fires term (~0.7-1.7 Gt CO2/yr) into EVERY bookkeeping
#' model's net, though only GCB's block breaks it out as a column (verified: each model's net exceeds the sum
#' of its ex-peat components by exactly that peat). So \code{+|Land-use Change} is already consistently
#' incl-peat across all four models, matching MAgPIE's \code{+|Land-use Change} (which also includes peat).
#' The function reads GCB's peat column and adds, for all four models, a matching \code{...|+|Peatland} child
#' (closing the net-vs-components gap) and \code{...|Land-use Change|Excl Peatland} (net of peat, matching
#' MAgPIE's peat-excluded line). Gasser and the national-statistics series are handled elsewhere.
#'
#' Axis 2 - INDIRECT (Grassi) - NOT represented in the ingested data. In principle the bookkeeping-vs-NGHGI
#' gap (~5 Gt CO2/yr; Grassi et al. 2021, doi:10.1038/s41558-021-01033-6) arises because country inventories,
#' reporting the sink-inclusive NET LULUCF over a large managed-land area, embed the environmental sink and
#' sit far BELOW bookkeeping ELUC - which would make net \code{Emissions|CO2|Land} the matching counterpart.
#' BUT none of the FAO_EmisLUC/EDGAR_LU/PRIMAPhist series ingested here is that Grassi-adjusted NGHGI net:
#' FAO is FAOSTAT's net "Land Use total" (its forest sink included but modest, so still a ~4 Gt SOURCE),
#' EDGAR/PRIMAP are LULUCF CO2 series - all positive, LUC-scale, none carrying a net-flux or Indirect sink
#' series. They must therefore be compared to MAgPIE's \code{+|Land-use Change} like the bookkeeping sources,
#' NOT to net Land. The sink-inclusive NGHGI-net quantity Grassi contrasts with bookkeeping is absent from
#' this validation cloud, so MAgPIE's own \code{+|Indirect} (its Grassi managed-land sink ~-5.6 Gt CO2/yr,
#' \code{i52_land_carbon_sink}) has no inventory counterpart here to validate against.
#'
#' GCB note - every workbook model's net INCLUDES the common peat drainage & fires (verified: World 2010, GCB
#' 5181 / BLUE 6156 / OSCAR 5775 / H&C 3612, each = its ex-peat components + ~943 peat). GCB's block is the
#' only one that lists peat as a separate column. That peat column is now read and attached as a +|Peatland
#' child to all four, so net = components + peat holds and the Excl Peatland variant matches MAgPIE's line.
#'
#' Do NOT benchmark net Land against GCB: the only Indirect / net \code{Emissions|CO2|Land} series here is
#' GCB's, where Indirect = the GCB terrestrial sink S_LAND over ALL land (World 2020: -11403 Mt CO2/yr,
#' ~the whole-biosphere sink), NOT the managed-land Grassi quantity MAgPIE reports.
#'
#' @author Michael Crawford, Florian Humpenoeder
#'
#' @param cumulative cumulative from y2000
#'
#' @return a MAgPIE object
#'
#' @examples
#' \dontrun{
#' calcOutput("ValidGlobalCarbonBudget")
#' }
calcValidGlobalCarbonBudget <- function(cumulative = FALSE) {

  allOut <- readSource("GlobalCarbonBudget")

  # Peatland: GCB folds the common peat drainage & fires term into EVERY bookkeeping model's net (verified:
  # each model's net exceeds the sum of its ex-peat components by exactly GCB's peat, ~0.3 GtC/yr; only GCB's
  # block breaks the peat out as a column). So +|Land-use Change is already consistently incl-peat across all
  # four models (matching MAgPIE's +|Land-use Change) and is left unchanged. This adds the matching +|Peatland
  # child (which closes the net-vs-components gap) and an Excl Peatland variant (net - peat, matching MAgPIE's
  # ...|Excl Peatland line).
  lucVar  <- "Emissions|CO2|Land|+|Land-use Change"
  peatVar <- "Emissions|CO2|Land|Land-use Change|+|Peatland"
  exclVar <- "Emissions|CO2|Land|Land-use Change|Excl Peatland"
  bkModels <- c("GCB", "BLUE", "H&C2023", "OSCAR")
  peat <- collapseNames(allOut[, , peatVar])   # GCB's common peat term (only GCB carries peatVar)
  # per-model peat child (matches MAgPIE +|Peatland) and Excl Peatland (net - peat). Select each model via its
  # sub-dimension (allOut carries "model" as sub-dim 3.1) and rename the variable sub-dim (3.2), so the new
  # items inherit allOut's structure and no model prefix is embedded in a name string.
  peatChild <- NULL
  excl <- NULL
  for (m in bkModels) {
    net   <- allOut[, , m][, , lucVar]
    peatM <- net
    peatM[, , ] <- peat[, , ]
    getNames(peatM, dim = 2) <- peatVar
    exclM <- net
    exclM[, , ] <- net[, , ] - peat[, , ]
    getNames(exclM, dim = 2) <- exclVar
    peatChild <- mbind(peatChild, peatM)
    excl      <- mbind(excl, exclM)
  }
  allOut <- allOut[, , peatVar, invert = TRUE]   # drop GCB-only peat memo; re-add as a child for all four models
  allOut <- mbind(allOut, peatChild, excl)

  allOut <- add_dimension(allOut, dim = 3.1, add = "scenario", nm = "historical")

  if (cumulative) {
    allOut[, "y1995", ] <- 0
    allOut <- magclass::as.magpie(apply(allOut, c(1, 3), cumsum))

    # convert from Mt CO2 per year to Gt C02 per year
    allOut <- allOut * 10e-4

    reportingNames <- magclass::getNames(allOut, dim = 3)
    reportingNames <- stringr::str_replace(
      reportingNames,
      "Emissions\\|CO2\\|Land(\\||$)",
      "Emissions|CO2|Land|Cumulative\\1"
    )
    magclass::getNames(allOut, dim = 3) <- reportingNames
  }

  # append units
  reportingNames <- magclass::getNames(allOut, dim = 3)
  if (cumulative) {
    reportingNames <- paste0(reportingNames, " (Gt CO2)")
  } else {
    reportingNames <- paste0(reportingNames, " (Mt CO2/yr)")
  }
  magclass::getNames(allOut, dim = 3) <- reportingNames

  return(list(
    x           = allOut,
    weight      = NULL,
    unit        = "Mt or Gt (if cumulative) CO2 per year",
    description = "Gross emissions, indirect emissions, and net land CO2 flux from GCB"
  ))
}
