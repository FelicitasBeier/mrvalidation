#' calcValidGS
#'
#' Returns historical FRA 2025 growing stock in million m3
#'
#' @param datasource Currently only  available for the "FAO" source
#' @param indicator type of indicator (relative or absolute)
#' @return List of magpie object with growing stock
#' @author Abhijeet Mishra
#' @import magpiesets
#' @importFrom magclass getNames
#' @importFrom magpiesets FRAnames
#'
calcValidGS <- function(datasource = "FRA2025", indicator = "relative") {

  if (datasource == "FRA2025") {
    a <- collapseNames(readSource("FRA2025", subtype = "growing_stock", convert = TRUE))
    # The FRA2025 source labels the primary/introduced growing-stock totals with an inconsistent
    # "gs_total_" prefix (all other categories use "gs_tot_"); normalise it so the category drops
    # and the "gs_tot_" name cleanup below match for every category (otherwise the absolute branch
    # leaks "introduced" and renders garbled names like "GS Total Primary Forest").
    getNames(a) <- gsub("gs_total_", "gs_tot_", getNames(a))
    indicatorname  <- "Resources|Growing Stock|"

    if (indicator == "absolute") {
      # drop the "introduced" plantation series and the broken FRA primary-forest series
      # (primary GS ~18 m3/ha area-weighted -> implausible; FRA reports it too sparsely to use)
      absolute <- a[, , grep(pattern = "gs_tot", x = getNames(a), value = TRUE)]
      absolute <- absolute[, , c("gs_tot_introduced", "gs_tot_primary"), invert = TRUE]
      indicatorname <- paste0(indicatorname, indicator, "|+|")
      out <- absolute
      getNames(out) <- gsub(pattern = "gs_tot_", replacement = "", x = getNames(out))
      getNames(out) <- FRAnames(getNames(out))
      unit <- "Mm3"
      weight <- NULL
    } else if (indicator == "relative") {
      # drop the "introduced" plantation series and the broken FRA primary-forest series (see above)
      relative <- a[, , grep(pattern = "gs_ha", x = getNames(a), value = TRUE)]
      relative <- relative[, , c("gs_ha_introduced", "gs_ha_primary"), invert = TRUE]
      indicatorname <- paste0(indicatorname, indicator, "|+|")
      out <- relative
      getNames(out) <- gsub(pattern = "gs_ha_", replacement = "", x = getNames(out))
      getNames(out) <- FRAnames(getNames(out))
      unit <- "m3/ha"
      weight <- collapseNames(readSource("FRA2025", subtype = "forest_area", convert = TRUE))
      getNames(weight) <- FRAnames(getNames(weight))
      weight <- weight[, , getNames(out)]
      getNames(weight) <- paste0(indicatorname, getNames(weight), " (", unit, ")")
      weight <- weight + 10^(-10)
    }

    getNames(out) <- paste0(indicatorname, getNames(out), " (", unit, ")")

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
  } else {
    stop("No validation data exists for the given datasource!")
  }

  return(list(x = out,
              weight = weight,
              unit = unit,
              description = "Growing stock from FAO FRA2025 data"))
}
