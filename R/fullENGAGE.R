#' @title fullENGAGE
#' @description retrieves validation data from mrcommons for the ENGAGE project
#'
#' @return validation data in IAMC reporting format
#' @author Florian Humpenoeder
#' @importFrom magclass write.report

fullENGAGE <- function() {

  convertENGAGE <- function(x) {
    scenario <- getNames(x, dim = 2)
    x <- collapseNames(x, collapsedim = 1)
    x <- collapseNames(x, collapsedim = 1)
    y <- new.magpie(getCells(x), seq(1970, 2015, by = 1), getNames(x), fill = NA, sets = names(dimnames(x)))
    jointYears <- intersect(getYears(y), getYears(x))
    y[, jointYears, ] <- x[, jointYears, ]
    y <- add_dimension(y, dim = 3.1, add = "scenario", scenario)
    y <- add_dimension(y, dim = 3.2, add = "model", "Reference")
    return(y)
  }

  out <- NULL

  x <- calcOutput(type = "ValidEmissions", datasource = "EDGAR_LU", aggregate = "REG+GLO")
  x <- convertENGAGE(x)
  out <- mbind(out, x)

  x <- calcOutput(type = "ValidEmissions", datasource = "PRIMAPhist", aggregate = "REG+GLO")
  x <- convertENGAGE(x)
  out <- mbind(out, x)

  x <- calcOutput(type = "ValidYield", datasource = "MadratLandInGFAOLUH", aggregate = "REG+GLO")
  x <- convertENGAGE(x)
  out <- mbind(out, x)

  x <- calcOutput(type = "ValidLand", datasource = "FAO_crop_past", aggregate = "REG+GLO")
  x <- convertENGAGE(x)
  out <- mbind(out, x)

  x <- calcOutput(type = "ValidLand", datasource = "FAO_forest", aggregate = "REG+GLO")
  x <- convertENGAGE(x)
  out <- mbind(out, x)

  x <- calcOutput(type = "ValidLand", datasource = "LUH3", aggregate = "REG+GLO")
  x <- convertENGAGE(x)
  out <- mbind(out, x)

  write.report(out, "tmp.csv")
}
