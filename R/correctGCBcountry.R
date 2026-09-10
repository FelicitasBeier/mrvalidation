#' @title correctGCBcountry
#' @description Set the structural NAs from the net-vs-gross country-coverage mismatch to zero. A few
#' countries are reported in only one of the two source files (e.g. net but no gross split); an
#' unreported flux contributes zero to a regional sum. Values already reported are left untouched.
#'
#' @param x magpie object returned by readGCBcountry
#' @return magpie object without NAs
#' @author Florian Humpenoeder
#' @seealso \code{\link[madrat]{readSource}}
#' @importFrom madrat toolConditionalReplace

correctGCBcountry <- function(x) {
  toolConditionalReplace(x, "is.na()", 0)
}
