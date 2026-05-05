#' @title calcValidLand
#'
#' @description Returns historical cropland, pasture and forest area from FAOSTAT that can
#' be used for model validation.
#'
#' @param datasource Currently available: \code{"FAO"}, \code{"LUH2v2"}, \code{"LUH3"}, \code{"MAgPIEown"}
#' and \code{"SSPResults"}
#' @return list of magpie object with data and weight
#' @author Ulrich Kreidenweis, Benjamin Bodirsky, Abhijeet Mishra, Mishko Stevanovic, Kristine Karstens
#' @importFrom utils read.csv
#' @importFrom magpiesets reportingnames
#' @importFrom magpiesets findset
#' @importFrom magclass time_interpolate
#'
calcValidLand <- function(datasource = "MAgPIEown") {

  minValue <- 0

  if (datasource == "FAO_crop_past") {

    faoLand <- calcOutput("FAOLand", aggregate = FALSE)
    data    <- collapseNames(faoLand[, , c("6620", "6655"), pmatch = TRUE])
    getNames(data) <- c("crop", "past")

    out <- data[, , c("crop", "past")]
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
    getNames(out, dim = 3) <- paste0("Resources|Land Cover|+|", reportingnames(getNames(out, dim = 3)), " (million ha)")
  } else if (datasource == "FRA2015") {

    fraForest   <- readSource("FAO_FRA2015", "fac")[, , c("Forest",
                                                          "NatFor",
                                                          "PrimFor",
                                                          "NatRegFor",
                                                          "PlantFor")]
    getNames(fraForest, dim = 1) <- c("Resources|Land Cover|+|Forest",
                                      "Resources|Land Cover|Forest|+|Natural Forest",
                                      "Resources|Land Cover|Forest|Natural Forest|+|Primary Forest",
                                      "Resources|Land Cover|Forest|Natural Forest|+|Secondary Forest",
                                      "Resources|Land Cover|Forest|+|Planted Forest")

    yPast <- magpiesets::findset("past", noset = "original")
    yPast <- as.integer(substring(yPast, 2, 5))
    yData <- getYears(fraForest, as.integer = TRUE)
    yInterpolate <- union(yPast[yPast >= min(yData)], yData)
    fraForest <- time_interpolate(fraForest, interpolated_year = yInterpolate,
                                  integrate_interpolated_years = TRUE, extrapolation_type = "constant")

    out <- fraForest
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
    getNames(out, dim = 3) <- paste0(getNames(out, dim = 3), " (million ha)")
  } else if (datasource == "FRA2025") {

    fraForest2025   <- readSource("FRA2025", "forest_area")

    # add secondary forest as difference between naturallyRegeneratingForest and primary forest
    fraForest2025 <- mbind(fraForest2025,
                           setNames(collapseNames(fraForest2025[, , "naturallyRegeneratingForest"]) -
                                      collapseNames(fraForest2025[, , "primary"]), "secondary"))
    fraForest2025[fraForest2025 < 0] <- 0
    fraForest2025 <- fraForest2025[, , c("forestArea",
                                         "naturallyRegeneratingForest",
                                         "primary",
                                         "secondary",
                                         "agroforestry",
                                         "plantedForest",
                                         "plantationForest",
                                         "otherPlantedForest")]

    getNames(fraForest2025, dim = 1) <- c("Resources|Land Cover|+|Forest",
                                          "Resources|Land Cover|Forest|+|Natural Forest",
                                          "Resources|Land Cover|Forest|Natural Forest|+|Primary Forest",
                                          "Resources|Land Cover|Forest|Natural Forest|+|Secondary Forest",
                                          "Resources|Land Cover|Cropland|+|Tree Cover",
                                          "Resources|Land Cover|Forest|+|Planted Forest",
                                          "Resources|Land Cover|Forest|Planted Forest|Plantations|+|Timber",
                                          "Resources|Land Cover|Forest|Planted Forest|Natural|+|NPI_NDC AR")
    yPast <- magpiesets::findset("past", noset = "original")
    yPast <- as.integer(substring(yPast, 2, 5))
    yData <- getYears(fraForest2025, as.integer = TRUE)
    yInterpolate <- union(yPast[yPast >= min(yData)], yData)
    fraForest2025 <- time_interpolate(fraForest2025, interpolated_year = yInterpolate,
                                      integrate_interpolated_years = TRUE, extrapolation_type = "constant")
    out <- fraForest2025
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
    getNames(out, dim = 3) <- paste0(getNames(out, dim = 3), " (million ha)")
  } else if (datasource %in% c("LUH2v2", "LUH3")) {

    if (datasource == "LUH2v2") {
      data <- calcOutput("LUH2v2", landuse_types = "magpie", irrigation = FALSE,
                         cellular = FALSE, selectyears = seq(1965, 2015, by = 5), aggregate = FALSE)
      forest <- calcOutput("LUH2v2", landuse_types = "LUH2v2", irrigation = FALSE,
                           cellular = FALSE, selectyears = seq(1965, 2015, by = 5), aggregate = FALSE)
    } else if (datasource == "LUH3") {
      data <- calcOutput("LUH3", landuseTypes = "magpie", irrigation = FALSE,
                         cellular = FALSE, aggregate = FALSE)
      forest <- calcOutput("LUH3", landuseTypes = "LUH3", irrigation = FALSE,
                           cellular = FALSE, aggregate = FALSE)
    }

    out <- data[, , c("crop", "past", "urban", "other", "forest")]
    getNames(out, dim = 1) <- paste0("Resources|Land Cover|+|", reportingnames(getNames(out, dim = 1)), " (million ha)")
    out <- mbind(out, setNames(dimSums(out, dim = 3), "Resources|Land Cover (million ha)"))

    forest <- forest[, , c("primf", "secdf")]
    getNames(forest) <- c("primforest", "secdforest")
    getNames(forest, dim = 1) <- paste0("Resources|Land Cover|Forest|Natural Forest|+|",
                                        reportingnames(getNames(forest, dim = 1)), " (million ha)")

    out <- mbind(out, forest)
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)

  } else if (datasource == "MAgPIEown") {

    x <- calcOutput("LanduseInitialisation", nclasses = "seven", aggregate = FALSE)
    x <- mbind(x, setNames(dimSums(x[, , c("primforest", "secdforest", "forestry")], dim = 3), "forest"))

    mainCat <- c("crop", "past", "urban", "other", "forest")
    main <- x[, , mainCat]
    getNames(main, dim = 1) <- paste0("Resources|Land Cover|+|",
                                      reportingnames(getNames(main[, , mainCat], dim = 1)), " (million ha)")
    main <- mbind(main, setNames(dimSums(main, dim = 3), "Resources|Land Cover (million ha)"))

    grassland <- setNames(calcOutput("LanduseInitialisation", nclasses = "nine",
                                     aggregate = FALSE)[, , c("past", "range")], c("pastr", "range"))
    grassland <- setNames(grassland, paste0("Resources|Land Cover|",
                                            reportingnames(getNames(grassland, dim = 1)), " (million ha)"))

    forest <- c("primforest", "secdforest", "forestry")
    forest <- x[, , forest]
    forest <- mbind(forest, setNames(dimSums(x[, , c("primforest", "secdforest")], dim = 3), "natrforest"))
    natrforest <- forest[, , c("primforest", "secdforest")]
    forest <- forest[, , c("forestry", "natrforest")]
    getNames(forest, dim = 1) <- paste0("Resources|Land Cover|Forest|+|",
                                        reportingnames(getNames(forest, dim = 1)), " (million ha)")
    getNames(natrforest, dim = 1) <- paste0("Resources|Land Cover|Forest|Natural Forest|+|",
                                            reportingnames(getNames(natrforest, dim = 1)), " (million ha)")

    out <- mbind(main, forest, natrforest, grassland)
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
  } else if (datasource == "SSPResults") {
    # Pick out Land Cover categories in SSPResults
    out <- calcOutput("ValidSSPResults", warnNA = FALSE, aggregate = FALSE)

    # for some unknown reason MESSAGE-GLOBIOM repots negative other land
    # which is why we have to lower the minimum value check to -100
    minValue <- -100

    selection <- c(
      "Land Cover (million ha)",
      "Land Cover|Built-up Area (million ha)",
      "Land Cover|Cropland (million ha)",
      "Land Cover|Cropland|Energy Crops (million ha)",
      "Land Cover|Forest (million ha)",
      "Land Cover|Forest|Forestry (million ha)",
      "Land Cover|Forest|Forestry|Harvested Area (million ha)",
      "Land Cover|Forest|Natural Forest (million ha)",
      "Land Cover|Other Arable Land (million ha)",
      "Land Cover|Other Land (million ha)",
      "Land Cover|Other Natural Land (million ha)",
      "Land Cover|Pasture (million ha)"
    )

    out <- out[, , selection]

    # Renaming reporting categories from SSPResults to MAgPie validation names
    # (not all SSP-categories have MAgPIE-equivalents)

    mapping <- toolGetMapping(type = "sectoral", name = "mappingSSPResultsToMAgPIEValid.csv", where = "mappingfolder")
    mappingFrom <- as.vector(mapping[, "SSPResults"])
    mappingTo <- as.vector(mapping[, "MAgPIEValid"])
    names(mappingTo) <- mappingFrom
    aNames <- getNames(out, dim = 3)
    getNames(out, dim = 3) <- mappingTo[aNames]
    getNames(out, dim = 3) <- paste0("Resources|", getNames(out, dim = 3))

  } else {
    stop("Given datasource currently not supported!")
  }

  names(dimnames(out))[3] <- "scenario.model.variable"
  names(dimnames(out))[1] <- "ISO"

  desc <- paste0("Cropland, pasture, urban, other land and forest area from FAO, LUH2v2, MAgPIE-Input and SSPresults.",
                 "\n Cropland: is the land under temporary agricultural crops (multiple-cropped areas are counted only",
                 "\n           once), temporary meadows for mowing or pasture, land under market and kitchen gardens",
                 "\n           and land temporarily fallow, and cultivated with long-term crops which do not have to",
                 "\n           be replanted for several years (such as cocoa and coffee); land under trees and shrubs",
                 "\n           producing flowers, such as roses and jasmine;",
                 "\n Pasture: is the land used permanently (for a period of five years or more) for herbaceous,",
                 "\n          forage crops either cultivated or naturally growing.",
                 "\n Forest: is the land spanning more than 0.5 hectares with trees higher than 5 metres and a",
                 "\n         canopy cover of more than 10 percent (includes temporarily unstocked areas)")

  return(list(x = out,
              weight = NULL,
              unit = "million ha",
              min = minValue,
              description = desc)
  )
}
