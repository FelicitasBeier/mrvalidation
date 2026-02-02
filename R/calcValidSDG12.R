#' calcValidSDG12
#'
#' Returns historical SDG12 Indicators_Sustainable Production and Consumption
#'
#' @param datasource FAO
#' @return List of magpie object with data and population
#' @author Edna J. Molina Bacca
#' @import magpiesets
#' @importFrom magclass getNames
#'
calcValidSDG12 <- function(datasource = "FAO") {
  x <- NULL

  if (datasource == "FAO") {

    indicatorname <- "SDG|SDG12|Food loss"
    unit <- "Mt"
    foodLoss <- readSource("FAO_online", subtype = "CBCrop")
    aggregation <- toolGetMapping("FAOitems_online.rda", type = "sectoral", where = "mrvalidation")
    # standarized items _ magpie object
    aAgg <- toolAggregate(foodLoss, rel = aggregation, from = "FAOaggregatedItem_fromWebsite",
                          to = "k", dim = 3.1, partrel = TRUE)
    # reading only waste data
    out <- collapseNames(aAgg[, , "waste"])
    # Used to determine the total food loss in each country
    out <- dimSums(out, na.rm = TRUE, dim = 3) / 1e6
    getNames(out) <- paste0(indicatorname, " (", unit, ")")
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
    x <- mbind(x, out)
    unitsX <- unit

    indicatorname <- "SDG|SDG12|Material footprint"
    unit <- "tDM/capita/yr"
    # reading only domestic supply
    out <- collapseNames(aAgg[, , "domestic_supply"])
    out <- dimSums(out, na.rm = TRUE, dim = 3)
    popul <- readSource("FAO_online", subtype = "Pop")
    popul <- popul[, , "Total_Population_Both_sexes_(persons)"] + 10^-10
    comYears <- intersect(getYears(out), getYears(popul))
    popul <- popul[, comYears, ]
    out <- out / setNames(popul, NULL)
    getNames(out) <- paste0(indicatorname, " (", unit, ")")
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
    x <- mbind(x, out)
    unitsX <- c(unitsX, unit)

    indicatorname <- "SDG|SDG12|Food waste"
    unit <- "kcal/cap/day"
    # Reads food supply including household waste
    avFood <- calcOutput(type = "FoodSupplyPast", aggregate = FALSE)[, , "kcal"]
    avFood <- dimSums(avFood, dim = 3)
    # Calculate expected intake. Source is Lutz2014. Average for male,female,ages.ssp1 (historical trend)
    intake <- calcOutput("Intake", aggregate = FALSE)
    intake <- intake[, , "B.All.SSP1"]
    # intersect years
    comYears <- intersect(getYears(avFood), getYears(intake))
    out <- setNames(avFood[, comYears, ] - intake[, comYears, ], NULL)
    # if the country doesn't have Supply data the value calculated would be less than 0
    out[out < 0] <- 0
    getNames(out) <- paste0(indicatorname, " (", unit, ")")
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
    commonYrs <- intersect(getYears(x), getYears(out))
    x <- mbind(x[, commonYrs, ], out[, commonYrs, ])
    unitsX <- c(unitsX, unit)
    popul <- popul[, commonYrs, ]

  } else {
    stop("No data exist for the given datasource!")
  }

  return(list(x = x,
              weight = popul,
              unit = unitsX,
              description = "The present function calculates validation data for the indicators relevant to SDG12 "))
}
