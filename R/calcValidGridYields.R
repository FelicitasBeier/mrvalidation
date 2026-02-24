#' @title calcValidGridYields
#' @description reports Yields on 0.5 degree grid
#'
#' @param datasource downscaledFAO or calibratedFAO
#' @param future if NULL no future values are returned (default).
#'               specify climate scenario (gcm:rcp), if future is needed
#' @param physical if true (default) physical area (croparea) used for yield calculation;
#'                 if false harvested area used for yield calculation
#'
#' @return List of magpie objects with results on cellular level, weight on cellular level, unit and description.
#' @author Benjamin Leon Bodirsky
#' @seealso
#' \code{\link{fullMADRATTOLPJML}}
#' @examples
#' \dontrun{
#' calcOutput("ValidGridYields")
#' }
#'
#' @importFrom magpiesets reportingnames
#' @importFrom magclass getComment<- clean_magpie
#' @importFrom madrat toolConditionalReplace
#' @importFrom stringr str_split

calcValidGridYields <- function(datasource = "downscaledFAO", future = NULL, physical = TRUE) {

  if (datasource == "downscaledFAO") {

    if (!is.null(future)) {
      stop("Future options is not available for source type 'downscaledFAO'.")
    }

    out <- calcOutput("FAOYield", cellular = TRUE, aggregate = FALSE, irrigation = TRUE, physical = physical)
    getNames(out, dim = 1) <- reportingnames(getNames(out, dim = 1))
    getNames(out, dim = 2) <- reportingnames(getNames(out, dim = 2))
    out <- clean_magpie(out)
    out <- dimOrder(out, perm = c(2, 1))
    getComment(out) <- NULL

  } else if (datasource == "calibratedLPJmL") {

    sizelimit <- getOption("magclass_sizeLimit")
    withr::with_options(magclass_sizeLimit = 1e+12)
    withr::defer(withr::with_options(magclass_sizeLimit = sizelimit))

    lpjml       <- "ggcmi_phase3_nchecks_bft_6277d36e"
    isimip      <- NULL
    climatetype <- "GSWP3-W5E5:historical"

    if (!is.null(future)) {

      if (grepl("\\+", future)) {

        tmp         <- unlist(str_split(future, "\\+"))
        climatetype <- tmp[1]

        if (any(grepl("lpjml:", tmp))) {
          i <- grep("lpjml:", tmp)
          lpjml  <- gsub("lpjml:", "", tmp[i])
        }

        if (any(grepl("isimip:", tmp))) {
          i <- grep("isimip:", tmp)
          isimip  <- gsub("isimip:", "", tmp[i])
        }


      } else {

        climatetype <- future

      }
    }

    refYear        <- "y2010"

    out <- calcOutput("YieldsMAgPIEcrops",
                      lpjml = lpjml,
                      climatetype = climatetype,
                      multicropping = physical,
                      calibration = list(refYear = refYear,
                                         refYields = physical,
                                         areaSource = "FAO",
                                         average = 5,
                                         aggregation = "country"),
                      aggregate = FALSE)[, , findset("kcr")]

    getNames(out, dim = 1) <- reportingnames(getNames(out, dim = 1))
    getNames(out, dim = 2) <- reportingnames(getNames(out, dim = 2))
    out <- clean_magpie(out)
    getComment(out) <- NULL

  } else {
    stop("Source not available.")
  }

  return(list(x = out,
              weight = NULL,
              unit = "t DM per ha physical area",
              description = "Crop yields by plant type and irrigation",
              isocountries = FALSE)
  )
}
