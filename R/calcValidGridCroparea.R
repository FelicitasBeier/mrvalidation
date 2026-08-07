#' @title calcValidGridCroparea
#' @description reports Croparea by crops on 0.5 degree grid in physical area
#'
#' @param physical if true (default) physical area; if false harvested area
#'
#' @return List of magpie objects with results on cellular level, weight on cellular level, unit and description.
#' @author Benjamin Leon Bodirsky
#' @seealso
#' \code{\link{fullMADRATTOLPJML}}
#' @examples
#' \dontrun{
#' calcOutput("ValidGridCroparea")
#' }
#'
#' @importFrom magpiesets reportingnames
#' @importFrom magclass getComment<-

calcValidGridCroparea <- function(physical = TRUE) {

  if (physical) {
    descName <- "physical area"
  } else {
    descName <- "harvested area"
  }

  out <- calcOutput("Croparea", cellular = TRUE, aggregate = FALSE,
                    physical = physical, irrigation = TRUE)
  getNames(out, dim = 1) <- reportingnames(getNames(out, dim = 1))
  getNames(out, dim = 2) <- reportingnames(getNames(out, dim = 2))
  out <- clean_magpie(out)
  out <- dimOrder(out, perm = c(2, 1))

  getComment(out) <- NULL

  return(list(x = out,
              weight = NULL,
              unit = "Mha",
              description = paste("Croparea by plant type and irrigation in", descName),
              isocountries = FALSE)
  )
}
