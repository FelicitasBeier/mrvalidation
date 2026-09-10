#' @title convertGCBcountry
#' @description Fill the country-level GCB bookkeeping fluxes to the standard ISO country list.
#'
#' @param x magpie object returned by readGCBcountry
#' @return magpie object on the 249 ISO countries
#' @author Florian Humpenoeder
#' @seealso \code{\link[madrat]{readSource}}
#' @importFrom madrat toolCountryFill

convertGCBcountry <- function(x) {
  toolCountryFill(x, fill = 0)
}
