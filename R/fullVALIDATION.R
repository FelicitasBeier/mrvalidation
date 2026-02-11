#' fullValidation
#'
#' Function that produces the complete validation data set used for evaluation of MAgPIE outputs
#'
#' @param rev data revision which should be used as input. Will be converted to
#' \code{\link[base]{numeric_version}} when called via \code{\link[madrat]{retrieveData}}.
#' @param aggregate an aggregation level, such as "region+global", to be used for all outputs
#' that are being aggregated.
#' @author Jan Philipp Dietrich, Benjamin Leon Bodirsky
#' @seealso
#' \code{\link[madrat]{readSource}},\code{\link[madrat]{getCalculations}},\code{\link[madrat]{calcOutput}}
#' @examples
#' \dontrun{
#' retrieveData("Validation")
#' }
#'
fullVALIDATION <- function(rev = 0.1, aggregate = "region+global") {

  if (rev < numeric_version("4.66")) {
    stop("mrvalidation(>= 2.34.0) does not support revision below 4.66 anymore. ",
         "Please use a older snapshot/version of the library, if you need older revisions.")
  }
  # all validation data regional aggregations happens here
  # for the first variable output calculation, append paramenter should be set to FALSE so that the
  # eventually exitsting "validation.mif" file is deleted at the begining.
  valfile <- "validation.mif"


  # Population and Income
  calcOutput(type = "ValidPopulation", aggregate = aggregate, file = valfile,
             append = FALSE, warnNA = FALSE, try = TRUE) # ready
  calcOutput(type = "ValidIncome", datasource = "WDI_SSPs",
             aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidAgFFGDP", datasource = "WDI", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidAgGDP", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidAgGDP", datasource = "FAO_consum", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidConsumptionValue", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidAgEmployment", datasource = "ILO", dataVersionILO = "Aug24", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidAgEmployment", datasource = "ILO_FAO", dataVersionILO = "Aug24", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidHourlyLaborCosts", datasource = "ILO_completed", dataVersionILO = "Aug24",
             aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidHourlyLaborCosts", datasource = "USDA_FAO_completed", dataVersionILO = "Aug24",
             aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidWageDevelopment", datasource = "ILO_completed", dataVersionILO = "Aug24", baseYear = 2000,
             aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidWageDevelopment", datasource = "ILO_completed", dataVersionILO = "Aug24", baseYear = 2010,
             aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidWageDevelopment", datasource = "USDA_FAO_completed", dataVersionILO = "Aug24",
             baseYear = 2000, aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidWageDevelopment", datasource = "USDA_FAO_completed", dataVersionILO = "Aug24",
             baseYear = 2010, aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidGini", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidPovertyLine", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)

  # Food Demand
  calcOutput(type = "ValidKcal", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidKcal", datasource = "FAOmassbalance", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidKcal", datasource = "FAOmassbalancepre2010", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidKcal", datasource = "FAOmassbalancepost2010", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLivestockShare", aggregate = aggregate, file = valfile,
             append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidVegfruitShare", aggregate = aggregate, file = valfile,
             append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLivestockDemStructure", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidFoodExpenditureShare", aggregate = aggregate, expenditureType = "agPrimary",
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidFoodExpenditure", aggregate = aggregate, expenditureType = "agPrimary",
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidFoodExpenditure", aggregate = aggregate, expenditureType = "agPrimary",
             datasource = "FAOpre2010", file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidFoodExpenditure", aggregate = aggregate, expenditureType = "agPrimary",
             datasource = "FAOpost2010", file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidFoodExpenditureShare", aggregate = aggregate, expenditureType = "food",
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidFoodExpenditure", aggregate = aggregate, expenditureType = "food",
             file = valfile, append = TRUE, try = TRUE)

  # Demand, Production, Trade, Self-Sufficiency
  calcOutput(type = "ValidDemand", aggregate = aggregate, file = valfile,
             append = TRUE, detail = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidDemand", aggregate = aggregate, file = valfile,
             append = TRUE, datasource = "FAOpre2010", detail = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidDemand", aggregate = aggregate, file = valfile,
             append = TRUE, datasource = "FAOpre2010", detail = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidDemandBioenergy", aggregate = aggregate, file = valfile,
             append = TRUE, warnNA = FALSE, try = TRUE) # ready
  calcOutput(type = "ValidProduction", aggregate = aggregate, file = valfile,
             append = TRUE, detail = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidProduction", aggregate = aggregate, file = valfile,
             datasource = "FAOpre2010",
             append = TRUE, detail = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidProduction", aggregate = aggregate, file = valfile,
             datasource = "FAOpost2010",
             append = TRUE, detail = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidTrade", aggregate = aggregate, file = valfile,
             append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidTrade", aggregate = aggregate, file = valfile,
             append = TRUE,  net_trade = FALSE, equalized = FALSE, try = TRUE) # ready
  calcOutput(type = "ValidTrade", aggregate = aggregate, file = valfile,
             datasource = "FAOpre2010",
             append = TRUE,  net_trade = FALSE, equalized = FALSE, try = TRUE) # ready
  calcOutput(type = "ValidTrade", aggregate = aggregate, file = valfile,
             datasource = "FAOpost2010",
             append = TRUE,  net_trade = FALSE, equalized = FALSE, try = TRUE) # ready
  calcOutput(type = "ValidTrade", aggregate = aggregate,
             datasource = "FAOBilateral", file = valfile,
             append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidTrade", aggregate = aggregate,
             datasource = "FAOBilateral",  file = valfile,
             append = TRUE,  net_trade = FALSE, equalized = FALSE, try = TRUE) # ready
  calcOutput(type = "ValidSelfsuff", aggregate = aggregate, file = valfile,
             append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidSelfsuff", aggregate = aggregate, file = valfile,
             datasource = "FAOpre2010", append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidSelfsuff", aggregate = aggregate, file = valfile,
             datasource = "FAOpost2010", append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidFeed", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidFeed", datasource = "FAOpre2010", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidFeed", datasource = "FAOpost2010", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidProcessing", datasource = "FAO", nutrient = "dm", detail = TRUE,
             indicator = "primary_to_process", file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidProcessing", datasource = "FAOpre2010", nutrient = "dm", detail = TRUE,
             indicator = "primary_to_process", file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidProcessing", datasource = "FAOpost2010", nutrient = "dm", detail = TRUE,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidProcessing", datasource = "FAO", nutrient = "dm", detail = TRUE,
             indicator = "secondary_from_primary", file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidProcessing", datasource = "FAOpre2010", nutrient = "dm", detail = TRUE,
             indicator = "secondary_from_primary", file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidProcessing", datasource = "FAOpost2010", nutrient = "dm", detail = TRUE,
             indicator = "secondary_from_primary", file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidGrassLSUha", aggregate = aggregate, datasource = "MAgPIEown",
             file = valfile, append = TRUE, try = TRUE)

  # Resources:
  # Croparea
  calcOutput(type = "ValidCroparea", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, detail = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidCroparea", datasource = "ostberg2023", aggregate = aggregate,
             file = valfile, append = TRUE, detail = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidCroparea", datasource = "FAOfallow", aggregate = aggregate,
             file = valfile, append = TRUE, detail = TRUE, try = TRUE) # ready

  # Land Cover
  calcOutput(type = "ValidLand", datasource = "FAO_crop_past", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLand", datasource = "FRA2015", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLand", datasource = "LUH3", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLand", datasource = "MAgPIEown", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLand", datasource = "SSPResults", aggregate = aggregate,
             file = valfile, append = TRUE, warnNA = FALSE, try = TRUE) # ready
  calcOutput(type = "ValidLand", datasource = "FRA2020", aggregate = aggregate,
             file = valfile, append = TRUE, warnNA = FALSE, try = TRUE) # ready

  # Land Cover Change
  calcOutput(type = "ValidLandChange", datasource = "FAO_crop_past", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLandChange", datasource = "FRA2015", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLandChange", datasource = "LUH3", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLandChange", datasource = "MAgPIEown", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidLandChange", datasource = "SSPResults", baseyear = 2005, # 1995 not available as baseyear
             aggregate = aggregate, file = valfile, append = TRUE, warnNA = FALSE, try = TRUE) # ready

  # WaterUsage
  calcOutput(type = "ValidWaterUsage", datasource = "foley_2011", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "shiklomanov_2000", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "wada_2011", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "wisser_2008", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "fischer_IIASA", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "hejazi_2013", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "molden_IWMI", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "seckler_IWMI", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "shiklomanov", aggregate = FALSE,
             file = "validation.mif", append = TRUE, try = TRUE)

  calcOutput(type = "ValidWaterUsage", datasource = "LPJmL:ipsl-cm5a-lr", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "MATSIRO:ipsl-cm5a-lr", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidWaterUsage", datasource = "MPI-HM:ipsl-cm5a-lr", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)

  # Area equipped for Irrigation
  calcOutput(type = "ValidAEI", datasource = "LUH3", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidAEI", datasource = "Mehta2024_Siebert2013", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidAEI", datasource = "HID", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidAEI", datasource = "GMIA", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)

  # Area actually irrigated
  calcOutput(type = "ValidAAI", datasource = "LUH3", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)
  calcOutput(type = "ValidAAI", datasource = "GMIA", aggregate = aggregate,
             file = "validation.mif", append = TRUE, try = TRUE)

  # Nitrogen
  calcOutput(type = "ValidNitrogenBudgetCropland", datasource = "Bodirsky", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidNitrogenBudgetCropland", datasource = "Lassaletta2014", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidNitrogenBudgetCropland", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidNitrogenBudgetCropland", datasource = "ACCMIP", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidNitrogenBudgetPasture", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidNitrogenBudgetNonagland", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidManure", datasource = "IPCC", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidManure", datasource = "Bodirsky", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidNitrogenSurplus", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)

  # Carbon
  calcOutput("ValidResidues", aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)

  # Carbon Stocks
  calcOutput("ValidCarbon", datasource = "LPJmL4_for_MAgPIE_44ac93de:GSWP3-W5E5:historical", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)

  # Growing Stocks
  calcOutput("ValidGS", datasource = "FAO", aggregate = aggregate, indicator = "relative",
             file = valfile, append = TRUE, try = TRUE)
  calcOutput("ValidGS", datasource = "FAO", aggregate = aggregate, indicator = "absolute",
             file = valfile, append = TRUE, try = TRUE)

  # GHG emissions
  calcOutput(type = "ValidEmissions", datasource = "EDGAR_LU", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissions", datasource = "CEDS", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissions", datasource = "FAO_EmisLUC", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE, warnNA = FALSE) # ready
  calcOutput(type = "ValidEmissions", datasource = "FAO_EmisAg", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE, warnNA = FALSE) # ready
  calcOutput(type = "ValidEmissions", datasource = "GFED", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissions", datasource = "EDGAR6", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissions", datasource = "PRIMAPhist", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissions", datasource = "IPCC", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissions", datasource = "Nsurplus2", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidAnnualCarbonLTS", datasource = "Lauk_et_al", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidAnnualCarbonLTS", datasource = "Johnston_Radeloff", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidAnnualCarbonLTS", datasource = "Johnston_Radeloff_P", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidCumulativeCarbonLTS", datasource = "Johnston_Radeloff", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidCumulativeCarbonLTS", datasource = "Johnston_Radeloff_P", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmisLucGasser", subtype = "bookkeeping", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissionsAFOLU", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissionsAFOLU", datasource = "FAO", aggregate = aggregate, cumulative = TRUE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissionsAFOLU", datasource = "EDGAR_LU", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissionsAFOLU", datasource = "EDGAR_LU", aggregate = aggregate, cumulative = TRUE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidEmissionsPeatland", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidGlobalCarbonBudget", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidGlobalCarbonBudget", aggregate = FALSE, cumulative = TRUE,
             file = valfile, append = TRUE, try = TRUE) # ready

  # Yield
  for (datasource in c("FAO", "Ostberg2023_FAO_LUH2v2")) {
    for (faoVersion in c("join2010", "FAOpre2010", "FAOpost2010")) {
      for (physical in c(TRUE, FALSE)) {
        calcOutput(type = "ValidYield", datasource = datasource, physical = physical,
                   faoVersion = faoVersion, aggregate = aggregate, file = valfile,
                   append = TRUE,
                   try = TRUE)
      }
    }
  }

  # Productivity
  calcOutput(type = "ValidTau", aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidTauPastr", aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidLSUdensity", aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidAgriResearchIntensity", aggregate = aggregate, datasource = "Pardey",
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidFeedConversion", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)



  # Prices
  calcOutput(type = "ValidPriceAgriculture", datasource = "WBGEM", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidPriceAgriculture", datasource = "IMPACT3.2.2World_Price", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE) # ready
  calcOutput(type = "ValidPriceAgriculture", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidPriceAgriculture", datasource = "IniFoodPrice", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE)

  calcOutput(type = "ValidPriceBioenergy", aggregate = aggregate, file = valfile, append = TRUE,
             warnNA = FALSE, try = TRUE) # ready
  calcOutput(type = "ValidPriceGHG",   datasource = "SSPResults", aggregate = aggregate,
             file = valfile, append = TRUE, warnNA = FALSE, try = TRUE)
  calcOutput(type = "ValidPriceLand",   datasource = "FAO_USDA", aggregate = aggregate,
             file = valfile, append = TRUE, warnNA = FALSE, try = TRUE)


  # PriceIndex
  calcOutput(type = "ValidPriceIndex", datasource = "FAO", baseyear = "y2010", round = TRUE,
             aggregate = aggregate, file = valfile, append = TRUE, try = TRUE)

  # SDG
  calcOutput(type = "ValidSDG1", datasource = "James", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidSDG12", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)

  # Forestry run specific
  calcOutput(type = "ValidTimber", aggregate = aggregate, file = valfile, append = TRUE, try = TRUE) # ready

  # Costs validation
  calcOutput(type = "ValidCostsOverall", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE) # Overall costs.
  calcOutput(type = "ValidCostsTransport", datasource = "GTAPtransport", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCostsTransport", datasource = "MAgPIEcalc", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCostsCapStocks", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCostsFertilizer", datasource = "FAO", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCostsLabor", datasource = "Vittis", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCostsTC", datasource = "Pardey", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCostsAEI", datasource = "IMPACT", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidTotalLaborCosts", datasource = "ILO", dataVersionILO = "Aug24", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidTotalLaborCosts", datasource = "USDA", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidTotalLaborCosts", datasource = "GTAP", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCostsTransport", datasource = "GTAPwholesale", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)

  calcOutput(type = "ValidFactorReqShares", subtype = "crop", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidFactorReqShares", subtype = "livestock", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)

  # Diversity indices
  calcOutput(type = "ValidBII", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCropareaDiversity", index = "shannon", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCropareaDiversity", index = "invsimpson", aggregate = aggregate,
             file = valfile, append = TRUE, try = TRUE)

  # Global surface temperature
  calcOutput(type = "ValidGlobalSurfaceTemp", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE)
  calcOutput(type = "ValidCMIP6", aggregate = FALSE,
             file = valfile, append = TRUE, try = TRUE)

}
