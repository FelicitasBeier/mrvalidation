#' @title calcValidTau
#'
#' @description Returns historical land use intensity estimates (tau).
#'
#' @param datasource Currently available: \code{"FAO2012"} (original data set)
#' and \code{"FAOonline"} (projection of tau values from 1995 based on recent FAO yield
#' projections.)
#' @return tau time series
#' @author Jan Philipp Dietrich

calcValidTau <- function(datasource = "FAO2012") {
  tau    <- readSource("Tau", "historical")
  if (datasource == "FAO2012") {
    out    <- collapseNames(tau[, , "tau.total"])
    weight <- collapseNames(tau[, , "xref.total"])
    sourceName <- "dietrich_et_al_2012"
    description <- "Historic Trends in Agricultural Land Use Intensity Tau based on FAO yield trends from 2012"
  } else if (datasource == "FAOonline") {
    prod <- collapseDim(readSource("FAO_online", "Crop")[, , "production"])
    itemsMap <- toolGetMapping("FAOitems.csv", type = "sectoral", where = "mappingfolder")
    prod <- toolAggregate(prod, dim = 3.1, rel = itemsMap, partrel = TRUE, from = "ProductionItem", to = "k")
    area <- calcOutput("Croparea", aggregate = FALSE)
    elem <- intersect(getItems(prod, dim = 3), getItems(area, dim = 3))
    years <-  intersect(getItems(prod, dim = 2), getItems(area, dim = 2))
    area  <- area[, years, elem]
    yield <- prod[, years, elem] / area

    yield[is.infinite(yield)] <- NaN
    area[is.na(yield)] <- 10^-10
    yield[is.na(yield)] <- 1
    yield <- lowpass(yield, 5)
    yieldIndex <- yield / setYears(yield[, 1995, ], NULL)

    # average growth rates of more than 20% per year are assumed to be incorrect
    maxYieldIndex <- (max(getYears(yield, as.integer = TRUE)) - 1995) * 0.2
    yieldIndex[yieldIndex > maxYieldIndex] <- 1

    tauHist <- collapseDim(dimSums(yieldIndex * area[, 1995, ], dim = 3) /
                             dimSums(area[, 1995, ], dim = 3) * tau[, 1995, "tau"])
    weight <- collapseDim(tau[, 1995, "xref"])
    weight <- magpie_expand(weight, tauHist)
    weight[is.na(tauHist)] <- 0
    tauHist[is.na(tauHist)] <- 0
    out <- tauHist
    description <- "Historic Trends in Agricultural Land Use Intensity Tau based on FAO yield trends (updated)"
    sourceName <- "dietrich_et_al_2012_updated"
  } else if (datasource == "FAOValidYields") {
    cropYieldVar <- "historical.FAO.Productivity|Yields|Yield by physical area|+|Crops (t DM/ha)"
    cropYields <- calcOutput("ValidYield", aggregate = FALSE)[, , cropYieldVar]
    yieldIndex <- collapseDim(cropYields / cropYields[, 1995, ])

    # average growth rates of more than 20% per year are assumed to be incorrect
    maxYieldIndex <- (max(getYears(yieldIndex, as.integer = TRUE)) - 1995) * 0.2
    yieldIndex[yieldIndex > maxYieldIndex] <- 1

    tauHist <- collapseDim(yieldIndex * tau[, 1995, "tau"])
    weight <- collapseDim(tau[, 1995, "xref"])
    weight <- magpie_expand(weight, tauHist)
    weight[is.na(tauHist)] <- 0
    tauHist[is.na(tauHist)] <- 0
    out <- tauHist
    description <- "Trends in Agricultural Land Use Intensity Tau based on FAO yield trends from calcValidYield"
    sourceName <- "yield validation FAO"
  } else {
    stop("Unknown datasource chosen in calcValidTau!")
  }


  names(dimnames(out))[3] <- "scenario.model.variable"
  getNames(out) <- paste0("historical.", sourceName,
                          ".Productivity|Landuse Intensity Indicator Tau (Index)")

  return(list(x = out,
              weight = weight,
              min = 0,
              max = 10,
              unit = "-",
              description = description,
              note = c("data uses initialization values for 1995 based on ",
                       "Dietrich J.P., Schmitz C., M\uFCller C., Fader M., Lotze-Campen H., Popp A.,",
                       "Measuring agricultural land-use intensity - A global analysis using a model-assisted approach",
                       "Ecological Modelling, Volume 232, 10 May 2012, 109-118, DOI 10.1016/j.ecolmodel.2012.03.002.",
                       "preprint available \u40 http://edoc.gfz-potsdam.de/pik/display.epl?mode=doc&id=5281")))

}
