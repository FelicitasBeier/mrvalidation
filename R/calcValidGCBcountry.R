#' @title calcValidGCBcountry
#' @description Regional bookkeeping land-use-change CO2 validation band (BLUE, OSCAR, Houghton &
#' Nassikas) from the Obermeier et al. (2024) country-level compilation. It gives every region a
#' bookkeeping band where previously only Gasser (OSCAR) existed regionally and the GCB workbook
#' ensemble was World-only.
#'
#' @details
#' The three bookkeeping models are native ex-peatland (they do not represent peat), so the net flux
#' is reported as \code{Emissions|CO2|Land|Land-use Change|Excl Peatland} - the like-for-like
#' counterpart to MAgPIE's Excl-Peatland line and to the ex-peat Gasser band (see
#' \code{\link{calcValidEmisLucGasser}}). Gross source and sink are reported as
#' \code{...|Land-use Change|Gross Positive} / \code{Gross Negative}, matching the magpie4 LUC-CO2
#' memos (net = Gross Positive + Gross Negative). Returned at ISO level with weight NULL so
#' \code{calcOutput} sums to the requested regions; \code{fullVALIDATION} requests regions only, since
#' the World bookkeeping cloud is already covered by \code{\link{calcValidGlobalCarbonBudget}}.
#'
#' @return list with a magpie object (Mt CO2/yr) and metadata
#' @author Florian Humpenoeder
#' @seealso \code{\link{calcValidEmisLucGasser}}, \code{\link{calcValidGlobalCarbonBudget}}

calcValidGCBcountry <- function() {

  # C -> CO2 via the molar-mass ratio 44/12 (M(CO2) = 44, M(C) = 12 g/mol); Mt C/yr -> Mt CO2/yr
  x <- readSource("GCBcountry", convert = TRUE) * 44 / 12

  # honest model labels (Houghton & Nassikas vintage kept as H&N; the World cloud labels its
  # Houghton member H&C2023)
  modelNames <- c(BLUE22 = "BLUE", OSCAR22 = "OSCAR", HN22 = "H&N")
  components <- c(net    = "Emissions|CO2|Land|Land-use Change|Excl Peatland",
                  source = "Emissions|CO2|Land|Land-use Change|Gross Positive",
                  sink   = "Emissions|CO2|Land|Land-use Change|Gross Negative")

  out <- NULL
  for (code in names(modelNames)) {
    m <- collapseNames(x[, , code], collapsedim = "model")
    getNames(m) <- paste0(components[getNames(m)], " (Mt CO2/yr)")
    m <- addDim(m, dim = 3.1, dimName = "scenario", item = "historical")
    m <- addDim(m, dim = 3.2, dimName = "model", item = modelNames[[code]])
    out <- mbind(out, m)
  }
  names(dimnames(out))[3] <- "scenario.model.variable"

  return(list(
    x           = out,
    weight      = NULL,
    unit        = "Mt CO2/yr",
    description = paste("Regional bookkeeping (BLUE / OSCAR / H&N) land-use-change CO2 fluxes,",
                        "ex-peatland net and gross source/sink, from Obermeier et al. 2024")
  ))
}
