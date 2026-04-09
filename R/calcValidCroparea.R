#' calcValidCroparea
#'
#' Returns historical areas of individual crops. These are derived by
#' correcting harvested areas to match to physical cropland areas. Both these
#' datasets are from FAO. Output is meant to be used for model validation.
#' Ostberg2023 is a slightly modified version of
#' https://gmd.copernicus.org/articles/16/3375/2023/gmd-16-3375-2023-assets.html
#'
#'
#' @param datasource Currently only "FAO" available
#' @param detail how much detail?
#' @return list of magpie object with data and weight
#' @author Benjamin Bodirsky, Ulrich Kreidenweis
#' @importFrom magpiesets reporthelper summationhelper
#' @importFrom magclass getNames
calcValidCroparea <- function(datasource = "FAO", detail = FALSE) {

  if (datasource == "FAO") {
    data <- calcOutput("Croparea", sectoral = "kcr", physical = TRUE, aggregate = FALSE)
    out <- reporthelper(x = data, dim = 3.1, level_zero_name = "Resources|Land Cover|Cropland|Croparea",
                        detail = detail)
    out <- summationhelper(out)
    getNames(out) <- paste(getNames(out), "(million ha)", sep = " ")

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
  } else if (datasource == "ostberg2023") {
    data <- calcOutput("CropareaLandInG", aggregate = FALSE)
    croparea <- reporthelper(
                             x = data, dim = 3.1,
                             level_zero_name = "Resources|Land Cover|Cropland|Croparea",
                             detail = detail)
    croparea <- summationhelper(croparea, sep = "+")
    fallow <- setNames(calcOutput("Fallow",
                                  aggregate = FALSE,
                                  cellular = FALSE),
                       paste("Resources|Land Cover|Cropland|+|", reportingnames("crop_fallow"), sep = ""))
    cropland <- setNames(dimSums(mbind(data, fallow), dim = 3.1),
                         "Resources|Land Cover|+|Cropland")
    cropareatotal <- setNames(dimSums(mbind(data), dim = 3.1),
                              "Resources|Land Cover|Cropland|+|Croparea")
    out <- mbind(cropland, cropareatotal, fallow, croparea)
    getNames(out) <- paste(getNames(out), "(million ha)", sep = " ")
    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = "Ostberg2023")
  } else if (datasource == "FAOfallow") {
    fallow <- calcOutput("FAOLand", aggregate = FALSE)[, , "6640", pmatch = TRUE]
    # cut off incomplete data before 2001
    out <- fallow[, getYears(fallow, as.integer = TRUE)[which(getYears(fallow, as.integer = TRUE) > 2000)], ]
    getNames(out) <- paste("Resources|Land Cover|Cropland|+|", reportingnames("crop_fallow"), sep = "")

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = "FAOSTAT")
  } else {
    stop("No data exist for the given datasource!")
  }

  return(list(x = out,
              weight = NULL,
              unit = "million ha",
              description = "")
  )
}
