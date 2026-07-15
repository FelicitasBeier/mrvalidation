#' @title calcValidCarbon
#' @description calculates the validation data for carbon pools
#'
#' @param datasource Datasources for validation data
#'
#' @return List of magpie objects with results on country level, weight on country level, unit and description.
#' @author Kristine Karstens
#'
#' @examples
#' \dontrun{
#' calcOutput("ValidCarbon")
#' }
#'
calcValidCarbon <- function(datasource = "LPJmL4_for_MAgPIE_44ac93de:GSWP3-W5E5:historical") {

  if (datasource == "LPJmL4_for_MAgPIE_44ac93de:GSWP3-W5E5:historical") {

    soilc <- calcOutput("LPJmL_new", version = "LPJmL4_for_MAgPIE_44ac93de",
                        climatetype = "GSWP3-W5E5:historical", stage = "raw", subtype = "soilc", aggregate = FALSE)
    litc  <- calcOutput("LPJmL_new", version = "LPJmL4_for_MAgPIE_44ac93de",
                        climatetype = "GSWP3-W5E5:historical", stage = "raw", subtype = "litc",  aggregate = FALSE)
    vegc  <- calcOutput("LPJmL_new", version = "LPJmL4_for_MAgPIE_44ac93de",
                        climatetype = "GSWP3-W5E5:historical", stage = "raw", subtype = "vegc",  aggregate = FALSE)

    nm <- "historical"

  } else if (grepl("LPJmL4", datasource) && !grepl("GSWP3-W5E5", datasource)) {

    version     <- gsub("^(.[^:]*):(.*)", "\\1", datasource)
    climatetype <- gsub("^(.[^:]*):(.*)", "\\2", datasource)

    soilc <- calcOutput("LPJmL_new", version = version, climatetype = climatetype,
                        subtype = "soilc", stage = "raw", aggregate = FALSE)
    litc  <- calcOutput("LPJmL_new", version = version, climatetype = climatetype,
                        subtype = "litc",  stage = "raw", aggregate = FALSE)
    vegc  <- calcOutput("LPJmL_new", version = version, climatetype = climatetype,
                        subtype = "vegc",  stage = "raw", aggregate = FALSE)

    nm <- "projection"

  } else {
    stop("No data exist for the given datasource!")
  }

  stock <- mbind(setNames(soilc, "soilc"), setNames(litc, "litc"), setNames(vegc, "vegc"))
  rm(soilc, litc, vegc)

  area  <- dimSums(calcOutput("LanduseInitialisation",
                              cellular = TRUE, years = "y1995",
                              aggregate = FALSE),
                   dim = 3)
  stock <- stock * setYears(area, NULL)

  stock <- dimSums(stock, dim = c("x", "y"))
  stock <- toolCountryFill(stock, fill = 0)

  stock <- mbind(
    setNames(dimSums(stock, dim = 3), "Resources|Carbon (Mt C)"),
    setNames(stock[, , "soilc"],      "Resources|Carbon|+|Soil (Mt C)"),
    setNames(stock[, , "litc"],       "Resources|Carbon|+|Litter (Mt C)"),
    setNames(stock[, , "vegc"],       "Resources|Carbon|+|Vegetation (Mt C)")
  )

  stock <- add_dimension(stock, dim = 3.1, add = "scenario", nm = nm)
  stock <- add_dimension(stock, dim = 3.2, add = "model",    nm = datasource)

  return(list(x = stock,
              weight = NULL,
              unit = "Mt C",
              description = "Carbon Stocks")
  )
}
