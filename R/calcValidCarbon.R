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
calcValidCarbon <- function(datasource = "LPJmL5:GSWP3-W5E5:historical") {
  # extract default arguments for LPJmL
  cfg <- toolLPJmLDefault()

  if (datasource == "LPJmL5:GSWP3-W5E5:historical") {
    # select chosen climatetype
    climatetype <- gsub("^(.[^:]*):(.*)", "\\2", datasource)

    soilc <- calcOutput("LPJmLTransform",
                        lpjmlversion = cfg$defaultLPJmLVersion,
                        climatetype = climatetype,
                        subtype     = "pnv:soilc", subdata = NULL,
                        stage       = "raw",
                        monthly     = FALSE,
                        aggregate   = FALSE)

    litc <- calcOutput("LPJmLTransform",
                       lpjmlversion = cfg$defaultLPJmLVersion,
                       climatetype = climatetype,
                       subtype     = "pnv:litc", subdata = NULL,
                       stage       = "raw",
                       monthly     = FALSE,
                       aggregate   = FALSE)

    vegc <- calcOutput("LPJmLTransform",
                       lpjmlversion = cfg$defaultLPJmLVersion,
                       climatetype = cfg$baselineHist,
                       subtype     = "pnv:vegc", subdata = NULL,
                       stage       = "raw",
                       monthly     = FALSE,
                       aggregate   = FALSE)

    nm <- "historical"

  } else if (grepl("LPJmL5", datasource) && !grepl("GSWP3-W5E5", datasource)) {
    # select climatetype
    climatetype <- gsub("^(.[^:]*):(.*)", "\\2", datasource)

    soilc <- calcOutput("LPJmLTransform",
                        lpjmlversion = cfg$defaultLPJmLVersion,
                        climatetype = climatetype,
                        subtype     = "pnv:soilc", subdata = NULL,
                        stage       = "raw",
                        monthly     = FALSE,
                        aggregate   = FALSE)

    litc <- calcOutput("LPJmLTransform",
                       lpjmlversion = cfg$defaultLPJmLVersion,
                       climatetype = climatetype,
                       subtype     = "pnv:litc", subdata = NULL,
                       stage       = "raw",
                       monthly     = FALSE,
                       aggregate   = FALSE)

    vegc <- calcOutput("LPJmLTransform",
                       lpjmlversion = cfg$defaultLPJmLVersion,
                       climatetype = climatetype,
                       subtype     = "pnv:vegc", subdata = NULL,
                       stage       = "raw",
                       monthly     = FALSE,
                       aggregate   = FALSE)


    nm <- "projection"

  } else {
    stop("No data exist for the given datasource!")
  }

  stock <- mbind(setNames(soilc, "soilc"), setNames(litc, "litc"), setNames(vegc, "vegc"))
  rm(soilc, litc, vegc)

  area  <- dimSums(calcOutput("LUH3", landuseTypes = "LUH3", irrigation = FALSE,
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
