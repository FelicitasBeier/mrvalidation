#' @title calcValidSOCStocks
#' @description calculates the validation data for the soil carbon pools
#'
#' @param datasource Datasources for validation data, e.g. LPJ_IPCC2006, SoilGrids
#' @param baseyear baseyear for calculating soil carbon stock change
#'
#' @return List of magpie objects with results on country level, weight on country level, unit and description.
#' @author Benjamin Leon Bodirsky, Kristine Karstens
#' @seealso
#' \code{\link[mrcommons]{calcFoodSupplyPast}},
#' \code{\link{calcValidLivestockShare}}
#' @examples
#' \dontrun{
#' calcOutput("ValidSOCStocks")
#' }
#'
#' @importFrom magpiesets reporthelper summationhelper
#' @importFrom magclass mbind getYears setYears nregions
#' @importFrom mstools toolCoord2Isocell

calcValidSOCStocks <- function(datasource = "histSOCbudget", baseyear = 1995) {

  if (datasource == "histSOCbudget") {

    steadyState  <- calcOutput("SteadyState", aggregate = FALSE)
    landuse      <- calcOutput("Landuse", aggregate = FALSE)[, getYears(steadyState), ]
    somStock     <- calcOutput("SoilCarbon", aggregate = FALSE, output = "actualstate")[, getYears(steadyState), ]
    natStock     <- calcOutput("SoilCarbon", aggregate = FALSE, output = "naturalstate")[, getYears(steadyState), ]

    somStock  <- mstools::toolConv2CountryByCelltype(dimSums(somStock, dim = 3.1), cells = "lpjcell")
    natStock  <- mstools::toolConv2CountryByCelltype(dimSums(natStock, dim = 3.1), cells = "lpjcell")
    equStock  <- mstools::toolConv2CountryByCelltype(dimSums(steadyState * landuse, dim = 3.1), cells = "lpjcell")

    somStock  <- mbind(somStock, add_dimension(dimSums(somStock, dim = 3.1), add = "landuse", nm = "total"))
    natStock  <- mbind(natStock, add_dimension(dimSums(natStock, dim = 3.1), add = "landuse", nm = "total"))
    equStock  <- mbind(equStock, add_dimension(dimSums(equStock, dim = 3.1), add = "landuse", nm = "total"))

    unit          <- "(Mt C)"
    zeroOrderName <- "Resources|Soil Carbon|Actual|Stock|SOC in top 30 cm"
    out <- mbind(setNames(somStock[, , "total"],  paste0(zeroOrderName, " ", unit)),
                 setNames(somStock[, , "crop"],   paste0(zeroOrderName, "|+|Cropland Soils ", unit)),
                 setNames(somStock[, , "natveg"], paste0(zeroOrderName, "|+|Noncropland Soils ", unit)))

    zeroOrderName <- "Resources|Soil Carbon|Target|Stock|SOC in top 30 cm"
    out <- mbind(out,
                 setNames(equStock[, , "total"],  paste0(zeroOrderName, " ", unit)),
                 setNames(equStock[, , "crop"],   paste0(zeroOrderName, "|+|Cropland Soils ", unit)),
                 setNames(equStock[, , "natveg"], paste0(zeroOrderName, "|+|Noncropland Soils ", unit)))

    somChang <- somStock - setYears(somStock[, baseyear, ], NULL)
    unit     <- paste0("Mt C wrt ", baseyear)
    zeroOrderName <- "Resources|Soil Carbon|Actual|Stock Change|SOC in top 30 cm"
    out <- mbind(out,
                 setNames(somChang[, , "total"],  paste0(zeroOrderName, " ", unit)),
                 setNames(somChang[, , "crop"],   paste0(zeroOrderName, "|+|Cropland Soils ", unit)),
                 setNames(somChang[, , "natveg"], paste0(zeroOrderName, "|+|Noncropland Soils ", unit)))

    somDebt <- natStock - somStock
    unit          <- "(Mt C)"
    zeroOrderName <- "Resources|Soil Carbon|Actual|Debt|SOC in top 30 cm"
    out <- mbind(out,
                 setNames(somDebt[, , "total"],  paste0(zeroOrderName, " ", unit)),
                 setNames(somDebt[, , "crop"],   paste0(zeroOrderName, "|+|Cropland Soils ", unit)),
                 setNames(somDebt[, , "natveg"], paste0(zeroOrderName, "|+|Noncropland Soils ", unit)))

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)

  } else if (datasource == "LPJ_IPCC2006") {

    mapping    <- toolGetMapping(name = "CountryToCellMapping.csv", type = "cell", where = "mappingfolder")
    somStock  <- calcOutput("SOM", subtype = "stock",   aggregate = FALSE)
    somStock  <- toolAggregate(somStock, rel = mapping,
                               from = ifelse(nregions(somStock) > 1, "celliso", "cell"), to = "iso", dim = 1)
    somStock  <- toolCountryFill(somStock, fill = 0)
    somStock  <- mbind(somStock, add_dimension(dimSums(somStock, dim = 3.1), add = "landuse", nm = "total"))

    out <- mbind(
      setNames(somStock[, , "total"][, , "soilc"],
               "Resources|Soil Carbon|Actual|Stock|SOC in top 30 cm (Mt C)"),
      setNames(somStock[, , "cropland"][, , "soilc"],
               "Resources|Soil Carbon|Actual|Stock|SOC in top 30 cm|+|Cropland Soils (Mt C)"),
      setNames(somStock[, , "noncropland"][, , "soilc"],
               "Resources|Soil Carbon|Actual|Stock|SOC in top 30 cm|+|Noncropland Soils (Mt C)")
    )

    somChang <- somStock - setYears(somStock[, baseyear, ], NULL)

    out <- mbind(out,
      setNames(somChang[, , "total"][, , "soilc"],
               paste0("Resources|Soil Carbon|Actual|Stock Change|",
                      "SOC in top 30 cm (Mt C wrt ", baseyear, ")")),
      setNames(somChang[, , "cropland"][, , "soilc"],
               paste0("Resources|Soil Carbon|Actual|Stock Change|",
                      "SOC in top 30 cm|+|Cropland Soils (Mt C wrt ", baseyear, ")")),
      setNames(somChang[, , "noncropland"][, , "soilc"],
               paste0("Resources|Soil Carbon|Actual|Stock Change|",
                      "SOC in top 30 cm|+|Noncropland Soils (Mt C wrt ", baseyear, ")"))
    )
    out <- mbind(out,
      setNames(somStock[, , "total"][, , "target_soilc"],
               "Resources|Soil Carbon|Target|Stock|SOC in top 30 cm (Mt C)"),
      setNames(somStock[, , "cropland"][, , "target_soilc"],
               "Resources|Soil Carbon|Target|Stock|SOC in top 30 cm|+|Cropland Soils (Mt C)"),
      setNames(somStock[, , "noncropland"][, , "target_soilc"],
               "Resources|Soil Carbon|Target|Stock|SOC in top 30 cm|+|Noncropland Soils (Mt C)")
    )

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)

  } else if (datasource == "GSOC") {

    soilc <- readSource("GSOC",  convert = "onlycorrect")
    area <- calcOutput("LandArea", aggregate = FALSE)
    stock <- soilc * area

    mapping <- toolGetMapping(name = "CountryToCellMapping.csv", type = "cell", where = "mappingfolder")
    stock   <- toolAggregate(stock, rel = mapping, from = "celliso", to = "iso", dim = 1)
    stock   <- toolCountryFill(stock, fill = 0)
    out     <- setNames(stock, "Resources|Soil Carbon|Actual|Stock|SOC in top 30 cm (Mt C)")

    out <- mbind(setYears(out, "y2015"), setYears(out, "y2016"), setYears(out, "y2017"))
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)

  } else if (datasource == "WISE") {

    soilc <- readSource("WISE",  convert = "onlycorrect")
    area <- calcOutput("LandArea", aggregate = FALSE)
    stock <- soilc * area

    mapping <- toolGetMapping(name = "CountryToCellMapping.csv", type = "cell", where = "mappingfolder")
    stock   <- toolAggregate(stock, rel = mapping, from = "celliso", to = "iso", dim = 1)
    stock   <- toolCountryFill(stock, fill = 0)
    out     <- setNames(stock, "Resources|Soil Carbon|Actual|Stock|SOC in top 30 cm (Mt C)")

    out <- mbind(setYears(out, "y1995"), setYears(out, "y2000"),
                 setYears(out, "y2005"), setYears(out, "y2010"))
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)

  } else if (datasource == "SoilGrids") {

    soilc <- toolCoord2Isocell(readSource("SoilGrids", subtype = "cstock_0_30", convert = "onlycorrect"))
    area <- calcOutput("LandArea", aggregate = FALSE)
    stock <- soilc * area

    mapping <- toolGetMapping(name = "CountryToCellMapping.csv", type = "cell", where = "mappingfolder")
    stock   <- toolAggregate(stock, rel = mapping, from = "celliso", to = "iso", dim = 1)
    stock   <- toolCountryFill(stock, fill = 0)
    out     <- setNames(stock, "Resources|Soil Carbon|Actual|Stock|SOC in top 30 cm (Mt C)")

    out <- mbind(setYears(out, "y1995"), setYears(out, "y2000"),
                 setYears(out, "y2005"), setYears(out, "y2010"))
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)

  } else {
    stop("No data exist for the given datasource!")
  }

  names(dimnames(out))[3] <- "scenario.model.variable"

  return(list(x = out,
              weight = NULL,
              unit = "Mt C",
              description = "Soil Carbon")
  )
}
