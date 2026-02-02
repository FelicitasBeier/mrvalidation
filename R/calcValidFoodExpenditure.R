#' @title calcValidFoodExpenditure
#' @description validation for food expenditure
#'
#' @param detail if FALSE, only major food commoditiy groups are shown.
#' @param datasource Datasource for demand (FAO, FAOpre2010, FAOpost2010)
#' @param expenditureType Either "agPrimary" for agricultural primary products (demand * prices),
#' or "food" for total food expenditure including value-added marketing margins based on
#' Chen et al. 2025 regression coefficients
#'
#' @return List of magpie object with results on country level, weight on country level, unit and description.
#' @author Benjamin Leon Bodirsky, David M Chen
#' @examples
#' \dontrun{
#' calcOutput("ValidFoodExpenditure")
#' }
#' @importFrom magpiesets findset
calcValidFoodExpenditure <- function(detail = FALSE, datasource = "FAO", expenditureType = "agPrimary") {

  price <- calcOutput("IniFoodPrice", datasource = "FAO", aggregate = FALSE)
  pop <- collapseNames(calcOutput("Population", scenario = "SSP2", aggregate = FALSE)[, , ])

  if (datasource == "FAO") {
    demand <- dimSums(calcOutput("FAOmassbalance",
                                 aggregate = FALSE)[, , c("food", "flour1")][, , "dm"], dim = c(3.2, 3.3))
    demand <- demand[, , getNames(price)]
  } else if (datasource == "FAOpre2010") {
    demand <- dimSums(calcOutput("FAOmassbalance",
                                 aggregate = FALSE,
                                 version = "pre2010")[, , c("food", "flour1")][, , "dm"], dim = c(3.2, 3.3))
    demand <- demand[, , getNames(price)]
  } else if (datasource == "FAOpost2010") {
    demand <- dimSums(calcOutput("FAOmassbalance",
                                 aggregate = FALSE,
                                 version = "post2010")[, , c("food", "flour1")][, , "dm"], dim = c(3.2, 3.3))
    demand <- demand[, , getNames(price)]
  } else {
    stop("unknown datasource")
  }

  demand <- demand[, , getNames(price)]
  pop <- pop[, getYears(demand), ]
  demandPc <- demand / pop[, getYears(demand), ]

  agPrimary <- demandPc * price

  if (expenditureType == "agPrimary") {
    out <- agPrimary
    levelZeroName <- "Household Expenditure|Agricultural Primary Products|Expenditure"
    description <- "Per-capita expenditure for agricultural primary products"

  } else if (expenditureType == "food") {
    # Total food expenditure including value-added marketing margins
    # based on Chen et al. 2025 regression coefficients

    gdp <- collapseNames(calcOutput("GDPpc", scenario = "SSP2", aggregate = FALSE)[, , ])
    gdp <- gdp[, getYears(demand), ]

    # Read Chen coefficients
    markupCoef <- readSource("ChenFoodPrices2025", subtype = "MarkupCoef", convert = FALSE)
    fafhCoef <- readSource("ChenFoodPrices2025", subtype = "FafhCoef", convert = FALSE)

    # Get attributes for wet matter conversion
    attr <- calcOutput("Attributes", aggregate = FALSE)
    nutrAttr <- calcOutput("NutritionAttributes", aggregate = FALSE)

    # Get products available in markup coefficients
    markupProducts <- getItems(markupCoef, dim = 3.1)

    # Calculate food kcal per capita (need to convert demand from dm to kcal)
    kcalPc <- demand[, , markupProducts] * nutrAttr[, getYears(demand), markupProducts][, , "kcal"] * 10^6

    # Calculate margins for food-at-home (FAH)
    marginFAH <- markupCoef[, , "fah"][, , "a"] * markupCoef[, , "fah"][, , "b"]^log(gdp) +
      markupCoef[, , "fah"][, , "c"] * attr[, , "wm"][, , markupProducts]
    marginFAH <- collapseNames(marginFAH / (nutrAttr[, getYears(marginFAH), markupProducts][, , "kcal"] * 10^6))

    # Calculate margins for food-away-from-home (FAFH)
    marginFAFH <- (markupCoef[, , "fafh"][, , "a"] * markupCoef[, , "fafh"][, , "b"]^log(gdp) +
                     markupCoef[, , "fafh"][, , "c"]) * attr[, , "wm"][, , markupProducts]
    marginFAFH <- collapseNames(marginFAFH / (nutrAttr[, getYears(marginFAFH), markupProducts][, , "kcal"] * 10^6))

    # Calculate FAFH share based on GDP
    fafhShr <- fafhCoef[, , "a_fafh"] + fafhCoef[, , "b_fafh"] * gdp
    fafhShr[fafhShr > 1] <- 1
    fafhShr[fafhShr < 0] <- 0

    # Calculate value-added expenditure per capita
    valueAddedExp <- collapseNames(
      fafhShr[, getYears(kcalPc), ] * kcalPc * marginFAFH[, getYears(kcalPc), ] +
        (1 - fafhShr[, getYears(kcalPc), ]) * kcalPc * marginFAH[, getYears(kcalPc), ]
    )

    # Total food expenditure = agricultural primary + value added
    out <- agPrimary[, , markupProducts] + valueAddedExp / pop[, getYears(valueAddedExp), ]
    levelZeroName <- "Household Expenditure|Food|Expenditure"
    description <- "Per-capita expenditure for food including value-added marketing margins"

  } else {
    stop("expenditureType must be either 'agPrimary' or 'food'")
  }

  out2 <- reporthelper(x = out,
                       level_zero_name = levelZeroName,
                       detail = detail,
                       partly = TRUE)
  out2[is.nan(out2)] <- 0
  out2 <- add_dimension(out2, dim = 3.1, add = "scenario", nm = "historical")
  out2 <- add_dimension(out2, dim = 3.2, add = "model", nm = datasource)

  return(list(
    x = out2,
    weight = pop,
    unit = "US$2017/capita",
    description = description
  ))
}
