#' @title calcValidSelfsuff
#' @description Validates self-sufficiency ration
#'
#' @param datasource Options of the source of data:  \code{FAO, FAOpre2010, FAOpost2010}.
#' @param detail Default is \code{TRU}. If \code{FALSE}, the subcategories of
#' groups are not reported (e.g. "soybean" within "oilcrops")
#'
#' @return List of magpie objects with results on country level, weight on country level, unit and description.
#' @author Benjamin Leon Bodirsky, Mishko Stevanovic
#' @examples
#' \dontrun{
#' calcOutput("ValidSelfsuff")
#' }
#'

#' @importFrom magpiesets reporthelper

calcValidSelfsuff <- function(datasource = "FAO", detail = TRUE) {

  if (datasource == "FAO") {
    mb <- collapseNames(calcOutput("FAOmassbalance", aggregate = FALSE)[, , "dm"])
  } else if (datasource == "FAOpre2010") {
    mb <- collapseNames(calcOutput("FAOmassbalance",
                                   version = "pre2010",
                                   aggregate = FALSE)[, , "dm"])
  } else if (datasource == "FAOpost2010") {
    mb <- collapseNames(calcOutput("FAOmassbalance",
                                   version = "post2010",
                                   aggregate = FALSE)[, , "dm"])
  } else {
    stop("No data exist for the given datasource!")
  }

  # self sufficiency
  tmp1 <- round(collapseNames(mb[, , c("production")]), 8)
  tmp2 <- round(collapseNames(mb[, , "domestic_supply"]), 8)
  tmp1 <- reporthelper(x = tmp1, dim = 3.1, level_zero_name = "Trade|Self-sufficiency", detail = detail)
  tmp2 <- reporthelper(x = tmp2, dim = 3.1, level_zero_name = "Trade|Self-sufficiency", detail = detail)
  out <- tmp1 / tmp2
  # NaN comes from both production and domestic supply being zero. By convention, we set it to 1.
  # infinite values come from zero domestic supply and positive production, also set to 1.
  out[is.na(out)] <- 1
  out[is.infinite(out)] <- 1


  out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
  out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
  names(dimnames(out))[3] <- "scenario.model.variable"
  getNames(out) <- paste0(getNames(out), " (1)")
  getNames(tmp2) <- paste0(getNames(tmp2), " (1)")
  return(list(x = out,
              weight = tmp2 + 10^-10,
              min = 0,
              unit = "1",
              description = "Agricultural trade Selfsufficiency")
  )
}
