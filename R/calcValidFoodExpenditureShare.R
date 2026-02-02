#' @title calcValidFoodExpenditureShare
#' @description validation for food expenditure share
#'
#' @param detail if FALSE, only major food commoditiy groups are shown.
#' @param expenditureType Either "agPrimary" for agricultural primary products share,
#' or "food" for total food expenditure share including value-added marketing margins
#'
#' @return List of magpie object with results on country level, weight on country level, unit and description.
#' @author Benjamin Leon Bodirsky, David M Chen
#' @examples
#' \dontrun{
#' calcOutput("ValidFoodExpenditureShare")
#' }
#'
calcValidFoodExpenditureShare <- function(detail = FALSE, expenditureType = "agPrimary") {

  expenditure <- calcOutput("ValidFoodExpenditure", aggregate = FALSE, expenditureType = expenditureType)
  gdp <- collapseNames(calcOutput("GDPpc", scenario = "SSP2", aggregate = FALSE)[, , ])
  gdp <- gdp[, getYears(expenditure), ]
  pop <- collapseNames(calcOutput("Population", scenario = "SSP2", aggregate = FALSE)[, , ])
  pop <- pop[, getYears(expenditure), ]

  expenditureShr <- expenditure / gdp
  expenditureShr[is.nan(expenditureShr)] <- 0
  getNames(expenditureShr) <- sub(pattern = "\\|Expenditure",
                                  replacement = "|Expenditure Share",
                                  x = getNames(expenditureShr))

  if (expenditureType == "agPrimary") {
    description <- "Share of expenditure for agricultural primary products"
  } else {
    description <- "Share of expenditure for food including value-added marketing margins"
  }

  return(list(
    x = expenditureShr,
    weight = gdp * pop,
    unit = "US$2017/US$2017",
    description = description
  ))
}
