#' calcValidAnnualCarbonLTS
#'
#' Returns historical Emissions stored in wood products
#'
#' @param datasource Currently available \code{"Lauk_et_al"} or \code{"Johnston_Radeloff"}
#' or \code{"Johnston_Radeloff_P"} (p = projection)
#' @return List of magpie object with Emissions in wood products
#' @author Abhijeet Mishra
#' @import magpiesets
#' @importFrom magclass getNames collapseNames

calcValidAnnualCarbonLTS <- function(datasource = "Lauk_et_al") {

  if (datasource == "Lauk_et_al") {
    emis <- collapseNames(readSource("CarbonLTS", subtype = datasource))
    names(dimnames(emis)) <- c("region", "year", "variable")

    indicatorname <- "Emissions|CO2|Land|Land-use Change|Wood products|+|Storage"
    unit <- "Mt CO2/yr"
    out <- emis
    getNames(out) <- paste0(indicatorname, " (", unit, ")")

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)

  } else if (datasource == "Johnston_Radeloff") {
    emis       <- readSource("CarbonLTS", subtype = datasource)
    annual     <- collapseNames(emis[, , "Annual (MtCO2/yr)"][, , "SSP2"])
    names(dimnames(annual)) <- c("region", "year", "variable")

    indicatorname <- "Emissions|CO2|Land|Land-use Change|Wood products|+|Storage"
    unit <- "Mt CO2/yr"
    getNames(annual) <- paste0(indicatorname, " (", unit, ")")

    future <- tail(getYears(annual), 10)

    outHistorical <- annual[, future, , invert = TRUE]

    outHistorical <- add_dimension(outHistorical, dim = 3.1, add = "scenario", nm = "historical")
    outHistorical <- add_dimension(outHistorical, dim = 3.2, add = "model", nm = datasource)

    out <- outHistorical


  } else if (datasource == "Johnston_Radeloff_P") {
    ## original data also contains future projections
    emis       <- readSource("CarbonLTS", subtype = "Johnston_Radeloff")
    annual     <- collapseNames(emis[, , "Annual (MtCO2/yr)"][, , "SSP2"])
    names(dimnames(annual)) <- c("region", "year", "variable")

    indicatorname <- "Emissions|CO2|Land|Land-use Change|Wood products|+|Storage"
    unit <- "Mt CO2/yr"
    getNames(annual) <- paste0(indicatorname, " (", unit, ")")

    future <- tail(getYears(annual), 10)

    outProjection <- annual[, future, ]

    outProjection <- add_dimension(outProjection, dim = 3.1, add = "scenario", nm = "projection")
    outProjection <- add_dimension(outProjection, dim = 3.2, add = "model", nm = datasource)

    out <- outProjection

  } else {
    stop("No validation data exists from the given datasource!")
  }

  return(list(x = out * -1, ## Sequestartion is reported as negative
              weight = NULL,
              unit = unit,
              description = "Annual sequestration from carbon stored in harvested wood.")
  )
}
