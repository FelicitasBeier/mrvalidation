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
#'   BLUE, OSCAR, H&C2023  \tab excl \tab bookkeeping ELUC (direct, ex-peat)               \cr
#'   GCB (this fn)         \tab excl \tab = mean(BLUE, OSCAR, H&C2023)                      \cr
#'   Gasser et al 2020     \tab excl \tab OSCAR bookkeeping                                 \cr
#'   FAO_EmisLUC           \tab incl \tab FAOSTAT net LULUCF ("Land Use total"), a source   \cr
#'   EDGAR_LU              \tab incl \tab EDGAR LULUCF CO2, a source                        \cr
#'   PRIMAPhist            \tab incl \tab PRIMAP-hist CAT5 (LUCF) CO2, a source             \cr
#' }
#'
#' Axis 1 - PEAT. Bookkeeping estimates exclude peat drainage/fire; the national-statistics series include
#' it (drained organic soils). MAgPIE's Land-use Change INCLUDES peat (separable via its \code{+|Peatland}
#' child), so the peat-clean bookkeeping comparison uses Land-use Change net of that peat child (magpie4's
#' \code{...|Land-use Change|Excl Peatland} line, where present, provides this directly). The peat term
#' (~1-1.5 Gt CO2/yr) is small relative to the source magnitude and does not move the inventories out of
#' the LUC cloud.
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
#' GCB note - the GCB column ingested here is the bookkeeping-model MEAN and is EX-peat: GCB ==
#' mean(BLUE, OSCAR, H&C2023) exactly (World 2020: 4298 == mean(5607, 4724, 2564)). The published GCB
#' ELUC additionally adds peat drainage/fire (a separate GCB.xlsx column) not folded into the ingested
#' net. GCB's peat column exists in the workbook but is intentionally not ingested (it could not be an
#' additive child of Land-use Change, since GCB's net excludes it).
#'
#' Do NOT benchmark net Land against GCB: the only Indirect / net \code{Emissions|CO2|Land} series here is
#' GCB's, where Indirect = the GCB terrestrial sink S_LAND over ALL land (World 2020: -11403 Mt CO2/yr,
#' ~the whole-biosphere sink), NOT the managed-land Grassi quantity MAgPIE reports.
#'
#' @author Michael Crawford
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

  # Ex-peatland alias: these bookkeeping sources are already ex-peat, so also expose their Land-use
  # Change under MAgPIE's peat-excluded memo name (Emissions|CO2|Land|Land-use Change|Excl Peatland)
  # for a like-for-like comparison. See @details.
  if (cumulative) {
    lucVar  <- "Emissions|CO2|Land|Cumulative|+|Land-use Change (Gt CO2)"
    exclVar <- "Emissions|CO2|Land|Cumulative|Land-use Change|Excl Peatland (Gt CO2)"
  } else {
    lucVar  <- "Emissions|CO2|Land|+|Land-use Change (Mt CO2/yr)"
    exclVar <- "Emissions|CO2|Land|Land-use Change|Excl Peatland (Mt CO2/yr)"
  }
  elucExclPeat <- allOut[, , lucVar]
  magclass::getNames(elucExclPeat, dim = 3) <- exclVar
  allOut <- mbind(allOut, elucExclPeat)

  return(list(
    x           = allOut,
    weight      = NULL,
    unit        = "Mt or Gt (if cumulative) CO2 per year",
    description = "Gross emissions, indirect emissions, and net land CO2 flux from GCB"
  ))
}
