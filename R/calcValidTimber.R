#' calcValidTimber
#'
#' Returns historical timber demand and production from FAO in
#' volumetric units (Mm3/yr). Variable names match reportTimber.
#'
#' @param datasource Currently only available for the "FAO" source
#' @return List of magpie object with data and population
#' @author Abhijeet Mishra, Florian Humpenoeder
#' @import magpiesets
#' @importFrom magclass getNames mbind collapseNames add_dimension dimSums setNames
#'
calcValidTimber <- function(datasource = "FAO") {
  if (datasource == "FAO") {
    timberDemand <- calcOutput("TimberDemand", aggregate = FALSE)
    # Subset to the two MAgPIE kforestry products only (avoid FAO aggregates like "Roundwood")
    products <- c("Industrial roundwood", "Wood fuel")
    dem <- collapseNames(timberDemand[, , "domestic_supply"])[, , products]
    prod <- collapseNames(timberDemand[, , "production"])[, , products]

    # FAO woodfuel stacking correction: FAO woodfuel volumes are in stacked m3 (stere),
    # not solid m3. Apply 0.65 to match MAgPIE's reportTimber which reports in solid m3.
    # Sources: FAO (2004) UWET Section 5.1.3; FAO/ITTO/UNECE (2020) Table 2.2.
    dem[, , "Wood fuel"] <- dem[, , "Wood fuel"] * 0.65
    prod[, , "Wood fuel"] <- prod[, , "Wood fuel"] * 0.65

    unit <- "Mm3/yr"

    # Demand: product-level and total
    demVol <- dem
    getNames(demVol) <- paste0("Timber|Volumetric|Demand|Roundwood|+|", getNames(demVol))
    demVolTotal <- setNames(dimSums(demVol, dim = 3),
                            "Timber|Volumetric|Demand|+|Roundwood")
    demVol <- mbind(demVolTotal, demVol)
    getNames(demVol) <- paste0(getNames(demVol), " (", unit, ")")

    # Production: product-level and total
    prodVol <- prod
    getNames(prodVol) <- paste0("Timber|Volumetric|Production|Roundwood|+|", getNames(prodVol))
    prodVolTotal <- setNames(dimSums(prodVol, dim = 3),
                             "Timber|Volumetric|Production|+|Roundwood")
    prodVol <- mbind(prodVolTotal, prodVol)
    getNames(prodVol) <- paste0(getNames(prodVol), " (", unit, ")")

    out <- mbind(demVol, prodVol)

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = "FAOSTAT FO")

  } else {
    stop("No data exist for the given datasource!")
  }

  return(list(
    x = out,
    weight = NULL,
    unit = unit,
    description = "Timber demand and production from FAO data (volumetric)"
  ))
}
