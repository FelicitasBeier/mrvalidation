#' @title ValidTauPastr
#' @description Calculates managed pastures Tau based on FAO yield trends for 1995.
#'
#' @return List of magpie objects with results on country level, weight on country level, unit and description.
#' @author Marcos Alves
#' @examples
#' \dontrun{
#' calcOutput("ValidTauPastr")
#' }
#'
calcValidTauPastr <- function() {
  past <- findset("past")
  # Production
  prod <- calcOutput("GrasslandBiomass", aggregate = FALSE)[, past, "pastr"]
  prod <- toolCountryFill(prod, fill = 0)

  # pasture areas
  area <- calcOutput("LUH2v2", landuse_types = "LUH2v2", cellular = FALSE, aggregate = FALSE)[, past, "pastr"]
  area <- toolCountryFill(area, fill = 0)

  # Adding 'otherland' as an extra source of grass biomass comparable
  # to managed pastures in India, Pakistan and Bangladesh.
  otherland <-
    calcOutput("LUH2v2",
      landuse_types = "LUH2v2",
      cellular = FALSE, aggregate = FALSE
    )[, past, c("secdn", "primn")]
  area["IND", , "pastr"] <-
    area["IND", , "pastr"] +
    setNames(dimSums(otherland["IND", , ], dim = 3), "pastr")
  area["BGD", , "pastr"] <-
    area["BGD", , "pastr"] +
    setNames(dimSums(otherland["BGD", , ], dim = 3), "pastr")
  area["PAK", , "pastr"] <-
    area["PAK", , "pastr"] +
    setNames(dimSums(otherland["PAK", , ], dim = 3), "pastr")

  # Actual yields
  yact <- prod[, past, ] / area[, past, ]
  yact[is.nan(yact) | is.infinite(yact)] <- 0

  # reference yields
  yref <- calcOutput("GrasslandsYields",
                     lpjml = "lpjml5p2_pasture",
                     climatetype = "MRI-ESM2-0:ssp245",
                     subtype = "/co2/Nreturn0p5", # nolint: absolute_path_linter.
                     lsu_levels = c(seq(0, 2.2, 0.2), 2.5), past_mngmt = "mdef",
                     aggregate = FALSE)[, past, "pastr.rainfed"]

  yrefWeights <- calcOutput("LUH2v2", landuse_types = "LUH2v2", cellular = TRUE,
                            aggregate = FALSE)[, past, "pastr"]
  cell2iso <- data.frame(cell = getItems(yref, 1, full = TRUE),
                         iso = getItems(yref, if (dimExists("iso", yref)) "iso" else 1.1, full = TRUE))
  yref <- toolAggregate(yref, rel = cell2iso, from = "cell", to = "iso", weight = yrefWeights + 10^(-10))
  yref <- toolCountryFill(yref, fill = 0)

  # tau calculation
  t <- yact[, past, ] / yref[, past, ]
  t[is.nan(t) | is.infinite(t)] <- 0
  t <- collapseNames(t)

  # replacing unrealistic high tau values by regional averages
  regMap <- toolGetMapping("regionmappingH12.csv", type = "regional", where = "madrat")
  tReg <- toolAggregate(t, rel = regMap, weight = area, from = "CountryCode", to = "RegionCode")
  regions <- regMap$RegionCode
  names(regions) <- regMap[, "CountryCode"]

  largeTC <- where(t >= 10)$true$individual # tau threshold
  colnames(largeTC)[1] <- "country"
  largeTC <- as.data.frame(largeTC)

  for (i in as.vector(largeTC[, "country"])) {
    for (j in as.vector(largeTC[largeTC$country == i, "year"])) {
      t[i, j, ] <- tReg[regions[i], j, ]
    }
  }

  names(dimnames(t))[3] <- "scenario.model.variable"
  getNames(t) <-
    "historical.MAgPIEOwn.Productivity|Landuse Intensity Indicator Tau managed pastures (Index)" # nolint

  return(list(
    x = t,
    weight = yref * area, # Xref
    unit = "-",
    description =
      "Historic Trends in managed pastures Land Use Intensity Tau based on FAO yield trends" # nolint
  ))
}
