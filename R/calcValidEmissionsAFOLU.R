#' @title ValidEmissionsAFOLU
#' @description validation for total and cumulative AFOLU emissions in CO2eq
#' @author Michael Crawford
#'
#' @param datasource current options are "FAO" and "EDGAR_LU"
#' @param cumulative cumulative from y2000
#'
#' @return MAgPIE object with emissions in CO2eq
#'
#' @examples
#' \dontrun{
#' calcOutput("ValidEmissionsAFOLU")
#' }
calcValidEmissionsAFOLU <- function(datasource = "FAO", cumulative = FALSE) {

  .convertGWP100AR6 <- function(x, old, conversion) {
    x <- x * conversion

    getNames(x) <- stringr::str_replace(getNames(x), old, "GWP100AR6")
    getNames(x) <- stringr::str_replace(getNames(x), paste0("Mt ", old, "/yr"), "Mt CO2e/yr")

    return(x)
  }

  # NB on the CO2 land-use-change component below: FAO_EmisLUC and EDGAR_LU are national-statistics /
  # inventory LULUCF series. As ingested they are positive LUC-scale SOURCES (~2800-5400 Mt CO2/yr): FAO is
  # FAOSTAT's net "Land Use total" (forest sink included but modest, still a source), EDGAR is LULUCF CO2 -
  # neither carries a net-flux or Indirect sink series. They therefore sit in the same LUC-source cloud as
  # the bookkeeping ELUC estimates and compare to MAgPIE's Emissions|CO2|Land|+|Land-use Change, NOT to net
  # Emissions|CO2|Land. (They are incl-peat - drained organic soils - but that term is small relative to the
  # source.) See calcValidGlobalCarbonBudget (@details) for the full peat/indirect scope of the LUC-CO2 cloud.
  if (datasource == "FAO") {
    #  FAO agricultural emissions (inclusive of the burning of crop residues)
    faoAg <- calcOutput("ValidEmissions", datasource = "FAO_EmisAg", aggregate = FALSE, warnNA = FALSE)
    faoAg <- faoAg[, , "historical"]

    # FAO emissions from land-use change
    faoLUC <- calcOutput("ValidEmissions", datasource = "FAO_EmisLUC", aggregate = FALSE, warnNA = FALSE)

    # Reduce to only years present for both datasets
    yearsPresent <- Reduce(f = intersect, x = Map(getYears, list(faoAg, faoLUC)))

    # These emissions, if summed, represent total emissions from FAO
    n2o <- faoAg[, yearsPresent, c("Emissions|N2O|Land|Biomass Burning|+|Burning of Crop Residues (Mt N2O/yr)",
                                   "Emissions|N2O|Land|+|Agriculture (Mt N2O/yr)")]

    ch4 <- faoAg[, yearsPresent, c("Emissions|CH4|Land|Biomass Burning|+|Burning of Crop Residues (Mt CH4/yr)",
                                   "Emissions|CH4|Land|+|Agriculture (Mt CH4/yr)")]

    co2 <- faoLUC[, yearsPresent, "Emissions|CO2|Land|+|Land-use Change (Mt CO2/yr)"]

    n2o <- .convertGWP100AR6(n2o, "N2O", 273)
    ch4 <- .convertGWP100AR6(ch4, "CH4", 27)
    co2 <- .convertGWP100AR6(co2, "CO2", 1)

    ag <- n2o + ch4 # these emissions now have the same names (i.e., in CO2e), and can thus be simply summed

    total <- mbind(ag, co2)

  } else if (datasource == "EDGAR_LU") {

    edgar <- calcOutput("LandEmissions", datasource = "EDGAR_LU", aggregate = FALSE)

    n2o <- .convertGWP100AR6(edgar[, , "Emissions|N2O|Land|+|Agriculture (Mt N2O/yr)"],     "N2O", 273)
    ch4 <- .convertGWP100AR6(edgar[, , "Emissions|CH4|Land|+|Agriculture (Mt CH4/yr)"],     "CH4", 27)
    co2 <- .convertGWP100AR6(edgar[, , "Emissions|CO2|Land|+|Land-use Change (Mt CO2/yr)"], "CO2", 1)

    ag <- n2o + ch4

    total <- mbind(ag, co2)

  }

  total <- dimSums(total, dim = 3) * 0.001 # Mt to Gt CO2e
  getSets(total)["d3.1"] <- "variable"
  getNames(total) <- "Emissions|GWP100AR6|Land (Gt CO2e/yr)"

  # Calculate cumulative emissions since y2000
  if (cumulative) {
    yearsFrom2000 <- seq(from = 2000, max(getYears(total, as.integer = TRUE)))
    total <- total[, yearsFrom2000, ] # Align historical time series to MAgPIE's accumulation start date
    total[, "y2000", ] <- 0

    total <- as.magpie(apply(total, c(1, 3), cumsum))

    getNames(total, dim = "variable") <- "Emissions|GWP100AR6|Land|Cumulative (Gt CO2e)"
  }

  total <- add_dimension(total, dim = 3.1, add = "scenario", nm = "historical")
  total <- add_dimension(total, dim = 3.2, add = "model", nm = datasource)

  return(list(x           = total,
              weight      = NULL,
              unit        = "CO2eq",
              description = paste0("Historical global GHG emissions, calculated by ", datasource)))

}
