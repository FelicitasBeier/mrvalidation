#' @title readBII
#' @description Read the Biodiversity Intactness Index from the Natural History
#' Museum. Two dataset subtypes:
#'   * "Phillips" (default) -- Phillips et al. 2021 BII-BTE, historical scenario,
#'     country-level, returned as ISO x year x scenario.variable.
#'   * "DePalma" -- De Palma et al. 2024 NHM v2.1.1 -- cellular x.y.iso on the
#'     67420-cell lpjcell grid, fraction (0-1). Country aggregation is left to
#'     the consumer (calcValidBII).
#' @seealso https://data.nhm.ac.uk/dataset/bii-bte,
#'   https://data.nhm.ac.uk/dataset/bii-developed-by-nhm-v2-1-1-limited-release,
#'   \code{\link{downloadBII}}, \code{\link{calcValidBII}}
#' @author Michael Crawford, Florian Humpenoeder
#'
#' @param subtype Dataset: "Phillips" (default, Phillips et al. 2021 historical
#' BII) or "DePalma" (De Palma et al. 2024 v2.1.1 rasters).
#' @param subset Phillips variable selection ("bii", "crops", "highintensityag",
#' "hpd", "pastureland", "qualitynatural", "urbanextent"; lists accepted).
#' Ignored for subtype = "DePalma".
#'
#' @return magclass object. Phillips: ISO x year x scenario.variable. DePalma:
#'   x.y.iso x year x "bii" (fraction 0-1).
#'
#' @details
#' The De Palma rasters are 5 arc-minute WGS84 GeoTIFFs. terra::aggregate
#' (fact = 6, fun = "mean") brings them to 30 arc-minute (unweighted mean is
#' fine within a 6x6 block); terra::project pins to the canonical 0.5-deg grid;
#' terra::extract samples the 67420 lpjcell coordinates. Source is percent
#' (0-100), divided by 100 for unit-parity with Phillips. The data sub-dim is
#' named "variable" so calcValidBII can use getNames(x, dim = "variable") <- ...
#' on both subtypes.
#'
#' @examples
#'
#' \dontrun{
#'   readSource("BII")                      # Phillips historical
#'   readSource("BII", subtype = "DePalma") # De Palma 2024 v2.1.1
#' }
#'
#' @importFrom dplyr filter mutate select
#' @importFrom tidyr drop_na
#' @importFrom rlang .data
#' @importFrom stringr str_match
#' @importFrom magclass as.magpie mbind getCells getNames getSets getYears
#' @importFrom terra rast aggregate project extract
#' @importFrom mstools toolGetMappingCoord2Country
#' @importFrom utils read.csv

readBII <- function(subtype = "Phillips", subset = "bii") {

  if (identical(subtype, "DePalma")) {
    years <- c(2000, 2005, 2010, 2015, 2020)
    files <- setNames(sprintf("bii-%d_v2-1-1.tif", years), as.character(years))
    missingFiles <- files[!file.exists(files)]
    if (length(missingFiles)) {
      stop("Missing BII v2.1.1 GeoTIFF(s): ", paste(missingFiles, collapse = ", "),
           ". Run downloadSource(\"BII\", subtype = \"DePalma\") first.")
    }
    map        <- toolGetMappingCoord2Country(pretty = TRUE)
    resolution <- terra::rast(resolution = 0.5)
    .read <- function(year, file) {
      r    <- terra::rast(file)
      r    <- terra::aggregate(r, fact = 6, fun = "mean", na.rm = TRUE)
      r    <- terra::project(r, resolution)
      vals <- terra::extract(r, map[c("lon", "lat")])[, 2]   # col 1 = ID
      m    <- as.magpie(vals, spatial = 1)
      getYears(m) <- year
      getNames(m) <- "bii"
      m
    }
    out <- do.call(mbind, Map(.read, years, files))
    getCells(out) <- paste(map$coords, map$iso, sep = ".")
    getSets(out)  <- c("x.y.iso", "t", "variable")
    return(out / 100)   # percent -> fraction (parity with Phillips)
  }

  # Phillips et al. 2021 (default): historical scenario only, subset = variable.
  # downloadBII ships the CSV resource; older source folders have the .rds.
  bii <- if (file.exists("BII_historical_and_SSPs.csv")) {
    utils::read.csv("BII_historical_and_SSPs.csv")
  } else {
    readRDS("BII_historical_and_SSPs.rds")
  }

  bii <- bii |>
    filter(.data$scenario == "historical" & .data$variable %in% subset)

  bii <- bii |>
    mutate(ISO = str_match(string = .data$area_code, pattern = "[A-Z]{3}")) |> # identify the country aggregation
    drop_na("ISO") |> # remove all non-country aggregations (e.g. global)
    select("ISO", "scenario", "variable", "year", "value")

  biiMag <- as.magpie(bii)

  biiMag <- toolCountryFill(biiMag) # Taiwan and many islands are missing from this dataset
  # For each NA, set BII to this year's mean value
  for (y in getYears(biiMag)) {
    biiMag[, y, ][which(is.na(biiMag[, y, ]))] <- mean(biiMag[, y, ], na.rm = TRUE)
  }

  biiMag <- magpiesort(biiMag)

  return(biiMag)
}
