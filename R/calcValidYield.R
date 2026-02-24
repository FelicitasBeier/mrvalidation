#' @title calcValidYield
#' @description
#' Calculates a dataset of agricultural production out of the combined
#' data of calcFAOharmonized(). Covers dry matter (DM) production.
#' Also returns areas of individual crops from FAOSTAT.
#' Total area can be lower or higher than arable land because of multicropping or fallow land.
#' Returns yield as calculated from area area and production.
#'
#' @param datasource Specify which datasource needs to be used.
#'                   Currently only "FAO", "Ostberg2023_FAO_LUH2v2" and
#'                   "calibratedLPJmL" is available.
#' @param future     if NULL no future values are returned (default).
#'                   specify climate scenario (gcm:rcp), if future is needed
#' @param physical if true (default) physical area (croparea) used for yield calculation;
#'                 if false harvested area used for yield calculation
#' @param faoVersion which FAO version to use (pre, post or joined 2010 data)
#' @return List of magpie objects with results on country level,
#'         weight on country level, unit,
#'         Max.&Min. values alongwith description.
#' @author Abhijeet Mishra, Isabelle Weindl, Florian Humpenoeder
#' @seealso
#' \code{\link[mrcommons]{calcFAOmassbalance}},
#' \code{\link[mrlandcore]{calcCroparea}}
#'
#' @examples
#' \dontrun{
#' calcOutput("ValidYield")
#' }
#' @importFrom magclass getNames<- as.magpie
#' @importFrom magpiesets reporthelper summationhelper findset

calcValidYield  <-  function(datasource = "FAO", faoVersion = "join2010", future = NULL, physical = TRUE) {

  if (physical) {
    indicatorName <- "Productivity|Yield"
    descName <- "physical area"
  } else {
    indicatorName <- "Productivity|Yield by harvested area"
    descName <- "harvested area"
  }

  if (datasource == "FAO") {

    if (!is.null(future)) stop("Future options is not available for source type 'FAO'.")

    # Calculate areas of individual crops and pasture
    croparea  <-  collapseNames(calcOutput("Croparea", sectoral = "kcr",
                                           physical = physical, aggregate = FALSE))
    pastarea  <-  setNames(calcOutput("LanduseInitialisation", aggregate = FALSE)[, , "past"],
                           "pasture")

    cyears <- intersect(getYears(croparea), getYears(pastarea))
    area <- mbind(croparea[, cyears, ], pastarea[, cyears, ])
    area <- summationhelper(reporthelper(area,
                                         level_zero_name = indicatorName),
                            sep = NULL)

    # Calculate production
    if (faoVersion == "join2010") {
      histproduction <- collapseNames(calcOutput("FAOmassbalance", aggregate = FALSE))
    } else if (faoVersion == "FAOpre2010") {
      histproduction <- collapseNames(calcOutput("FAOmassbalance", version = "pre2010", aggregate = FALSE))
    } else if (faoVersion == "FAOpost2010") {
      histproduction <- collapseNames(calcOutput("FAOmassbalance", version = "post2010", aggregate = FALSE))
    }

    # extract DryMatter(dm) from production data
    # Extract Production from subsetted production data containing only DryMatter(dm)
    histproduction  <-  collapseNames(histproduction[, , "dm"][, , "production"])

    # Figure out which commodities are common and make sure that production and area has same commodity names
    kcr <- findset("kcr")
    cropproduction  <-  histproduction[, , kcr]
    pastproduction  <-  histproduction[, , "pasture"]
    production <- mbind(cropproduction, pastproduction)

    # Calculate Yields
    production <- summationhelper(reporthelper(production,
                                               level_zero_name = indicatorName),
                                  sep = NULL)
    cyears <- intersect(getYears(production), getYears(area))
    yield <- production[, cyears, ] / area[, cyears, ]

    # Check for NaN values
    indexNaN  <-  which(is.nan(yield))
    # Change NaN to 0
    yield[is.nan(yield)] <- 0
    if (length(indexNaN) > 0) {
      vcat(verbosity = 2, "NaN values were found in the calculated yields ---> NaN values set to 0")
    } else if (length(indexNaN) == 0) {
      vcat(verbosity = 2, paste0("No NaN values detected in calculated yields. ",
                                 "Yields for area reported as 0 are converted to 0."))
    }

    # Check for infinite values - Production reported but on 0 area
    infindex  <-  which(is.infinite(yield)) # Lots of inf values. Being too diplomatic FAO aren't we!!
    # Change inf to 0
    yield[is.infinite(yield)] <- 0
    if (length(infindex) > 0) {
      vcat(verbosity = 2, "inf values were found in the calculated yields ---> inf values set to 0")
    } else if (length(infindex) == 0) {
      vcat(verbosity = 2, "No inf values found in the calculated yields")
    }

    ## Additional checks required because we are reporting insanely high yields
    ## Check which(yield>200,arr.ind = TRUE)
    ## looks like Vatican are the best producers of oil

    ## We decided to set these outliers to 0
    # look for the Region names which are outliers
    region   <- rownames(which(yield > 200, arr.ind = TRUE))
    # look for the Years where reporting is flawed
    year     <- which(yield > 200, arr.ind = TRUE)[, 2]
    # look for the scenario.model.Variable where reporting is flawed
    variable <- which(yield > 200, arr.ind = TRUE)[, 3]

    ## Now do the operation of our magpie object
    yield[region, year, variable]  <-  0
    vcat(verbosity = 2, paste0("Yields>200 ton/ha were converted to 0 ",
                               "when area and production values were ambiguous"))

    scenario    <- "historical"
    description <- paste("FAO massbalance production divided by", descName, " from FAO.")

  } else if (datasource == "Ostberg2023_FAO_LUH2v2") {

    if (!is.null(future)) stop("Future options is not available for source type 'FAO'.")

    # Calculate areas of individual crops and pasture
    croparea <- calcOutput("CropareaLandInG", aggregate = FALSE, physical = physical)
    pastarea  <-  setNames(calcOutput("LanduseInitialisation", aggregate = FALSE)[, , "past"],
                           "pasture")

    cyears <- intersect(getYears(croparea), getYears(pastarea))
    area <- mbind(croparea[, cyears, ], pastarea[, cyears, ])
    area <- summationhelper(reporthelper(area,
                                         level_zero_name = indicatorName),
                            sep = NULL)

    # Calculate production
    if (faoVersion == "join2010") {
      histproduction <- collapseNames(calcOutput("FAOmassbalance", aggregate = FALSE))
    } else if (faoVersion == "FAOpre2010") {
      histproduction <- collapseNames(calcOutput("FAOmassbalance", version = "pre2010", aggregate = FALSE))
    } else if (faoVersion == "FAOpost2010") {
      histproduction <- collapseNames(calcOutput("FAOmassbalance", version = "post2010", aggregate = FALSE))
    }

    # extract DryMatter(dm) from production data
    # Extract Production from subsetted production data containing only DryMatter(dm)
    histproduction  <-  collapseNames(histproduction[, , "dm"][, , "production"])

    # Figure out which commodities are common and make sure that production and area has same commodity names
    kcr <- findset("kcr")
    cropproduction  <-  histproduction[, , kcr]
    pastproduction  <-  histproduction[, , "pasture"]
    production <- mbind(cropproduction, pastproduction)

    # Calculate Yields
    production <- summationhelper(reporthelper(production,
                                               level_zero_name = indicatorName),
                                  sep = NULL)
    cyears <- intersect(getYears(production), getYears(area))
    yield <- production[, cyears, ] / area[, cyears, ]

    # Check for NaN values
    indexNaN  <-  which(is.nan(yield))
    # Change NaN to 0
    yield[is.nan(yield)] <- 0
    if (length(indexNaN) > 0) {
      vcat(verbosity = 2, "NaN values were found in the calculated yields ---> NaN values set to 0")
    } else if (length(indexNaN) == 0) {
      vcat(verbosity = 2, paste0("No NaN values detected in calculated yields. ",
                                 "Yields for area reported as 0 are converted to 0."))
    }

    # Check for infinite values - Production reported but on 0 area
    infindex  <-  which(is.infinite(yield)) # Lots of inf values. Being too diplomatic FAO aren't we!!
    # Change inf to 0
    yield[is.infinite(yield)] <- 0
    if (length(infindex) > 0) {
      vcat(verbosity = 2, "inf values were found in the calculated yields ---> inf values set to 0")
    } else if (length(infindex) == 0) {
      vcat(verbosity = 2, "No inf values found in the calculated yields")
    }

    ## Additional checks required because we are reporting insanely high yields
    ## Check which(yield>200,arr.ind = TRUE)
    ## looks like Vatican are the best producers of oil

    ## We decided to set these outliers to 0
    # look for the Region names which are outliers
    region   <- rownames(which(yield > 200, arr.ind = TRUE))
    # look for the Years where reporting is flawed
    year     <- which(yield > 200, arr.ind = TRUE)[, 2]
    # look for the scenario.model.Variable where reporting is flawed
    variable <- which(yield > 200, arr.ind = TRUE)[, 3]

    ## Now do the operation of our magpie object
    yield[region, year, variable]  <-  0
    vcat(verbosity = 2, paste0("Yields>200 ton/ha were converted to 0 ",
                               "when area and production values were ambiguous"))

    scenario    <- "historical"
    description <- paste("FAO massbalance production divided by", descName,
                         " from Ostberg et al 2023 (excluding fallow land)")

  } else if (datasource == "calibratedLPJmL") {

    irrigation <- FALSE # can be made function argument if needed
    yieldLPJmLgrid <- calcOutput("ValidGridYields", datasource = "calibratedLPJmL",
                                 future = future, aggregate = FALSE, physical = physical)
    areaMAGgrid    <- setYears(calcOutput("ValidGridCroparea", aggregate = FALSE,
                                          physical = physical)[, "y2010", ], NULL)

    cell2iso <- data.frame(cell = getItems(yieldLPJmLgrid, 1, full = TRUE),
                           iso = getItems(yieldLPJmLgrid,
                                          if (dimExists("iso", yieldLPJmLgrid)) "iso" else 1.1, full = TRUE))

    yield <- toolAggregate(yieldLPJmLgrid, weight = areaMAGgrid, rel = cell2iso,
                           from = "celliso", to = "iso", dim = 1)
    area <- toolAggregate(areaMAGgrid, weight = NULL, rel = cell2iso,
                          from = "celliso", to = "iso", dim = 1)


    rm(yieldLPJmLgrid, areaMAGgrid)

    if (irrigation == FALSE) {
      yield <- dimSums(yield * area, dim = "data1") / (dimSums(area, dim = "irrigation") + 10^-10)
      area <- dimSums(area, dim = "irrigation")
    }

    yield <- toolCountryFill(yield, 0)
    area <- toolCountryFill(area, 0)
    yield <- setNames(yield, paste0(indicatorName, "|", gsub("\\.", "|", getNames(yield))))
    area <- setNames(area, paste0(indicatorName, "|", gsub("\\.", "|", getNames(area))))

    scenario    <- "projection"
    description <- paste("Projected yields from LPJmL calibrated to FAO based on", descName)

  } else {
    stop("specified datasource doesn't exist")
  }

  # Change the name of calculated element to YIELD
  # Units added to be consistent with getReport from gdx file.
  getNames(yield)  <-  paste0(getNames(yield), " (t DM/ha)")

  # Set areas as weight
  weight  <-  area + 10^-10
  # Important to change the names again so that ".dimextract" doesn't get confused
  getNames(weight)  <-  paste0(getNames(weight), " (t DM/ha)")

  # rename dimensions to be consistent with MAgPIE coding etiquette
  yield  <-  add_dimension(yield, dim = 3.1, add = "scenario", nm = scenario)
  yield  <-  add_dimension(yield, dim = 3.2, add = "model", nm = datasource)

  names(dimnames(yield))[3]  <-  "scenario.model.variable"

  return(list(x = yield,
              weight = weight[, getYears(yield), ],
              unit = "t DM/ha",
              max = 200,
              min = 0,
              description = description))
}
