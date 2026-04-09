#' @title calcValidCropareaDiversity
#' @description calculates validation for croparea diversity index. As opposed to
#' CropareaDiversityIndex from magpie4 due to lack of data fallow land is not considered
#'
#' @export
#'
#' @param index can be "shannon", "gini" or "invsimpson" for different types of diversitiy indices
#' @param groupdiv should crop groups be split up into several individual items or not?
#' Choose either FALSE or different (dis)aggregation methods "agg1", "agg2"
#' @return MAgPIE object (unit depends on attributes)
#' @author Patrick v. Jeetze, Benjamin Leon Bodirsky
#' @examples
#' \dontrun{
#' x <- calcOutput("ValidCropareaDiversity", index = "shannon", groupdiv = "agg1", aggregate = FALSE)
#' }
#'
calcValidCropareaDiversity <- function(index = "shannon", groupdiv = "agg1") {

  area <- readSource("LandInG", subtype = "harvestedArea")
  area <- area[, , c("pasture"), invert = TRUE]
  area <- collapseNames(area[, , "irrigated"]) + collapseNames(area[, , "rainfed"])
  fallow <- calcOutput("Fallow", aggregate = FALSE, cellular = TRUE)
  fallow <- setNames(fallow, "fallow")
  area <- mbind(area, fallow)

  land <- dimSums(area, dim = 3)

  ### honor to function dineq:::gini.wtd !
  gini <- function(x) {
    weights <- rep(1, length(x))
    weights <- weights / sum(weights)
    order <- order(x)
    x <- x[order]
    weights <- weights[order]
    p <- cumsum(weights)
    nu <- cumsum(weights * x)
    n <- length(nu)
    nu <- nu / nu[n]
    gini <- sum(nu[-1] * p[-n]) - sum(nu[-n] * p[-1])
    return(gini)
  }
  ### honor to function vegan:::diversity !
  shannon <- function(x, base = exp(1)) {
    x <- x / sum(x)
    x <- -x * log(x, base)
    h <- sum(x, na.rm = TRUE)
    return(h)
  }
  invsimpson <- function(x) {
    x <- x / sum(x)
    x <- x * x
    h <- sum(x, na.rm = TRUE)
    h <- 1 / h
    return(h)
  }

  selectIndex <- function(x, index) {
    if (index == "shannon") {
      x <- shannon(x)
    } else if (index == "invsimpson") {
      x <- invsimpson(x)
    } else if (index == "gini") {
      x <- gini(x)
    } else {
      stop("unknown index")
    }
    return(x)
  }

  # as opposed to CropareaDiversityIndex in magpie4 due to lack of data fallow land is not considered here

  cropdiv <- function(cellvalue, cropnames) {
    cellvalue <- as.vector(cellvalue)
    names(cellvalue) <- cropnames
    # weights could be improved
    if (groupdiv == "agg1") {
      single <- c("maiz", "trce", "rice_pro", "soybean", "rapeseed", "groundnut",
                  "sunflower", "oilpalm", "potato", "sugr_cane", "sugr_beet",
                  "cottn_pro", "begr")
      mix <- c(
        cellvalue[single],
        rep(cellvalue["foddr"] / 4, 4),
        rep(cellvalue["tece"] / 2, 2),
        rep(cellvalue["puls_pro"] / 3, 3),
        rep(cellvalue["betr"] / 2, 2),
        rep(cellvalue["cassav_sp"] / 2, 2),
        rep(cellvalue["fallow"] / 4, 4),
        rep(cellvalue["others"] / 10, 10)
      )
    } else if (groupdiv == "agg2") {
      mix <- c(
        cellvalue["tece"], #c3
        cellvalue["maiz"] + cellvalue["trce"], #c4
        cellvalue["rice_pro"], #rice
        cellvalue["puls_pro"] + cellvalue["soybean"] + cellvalue["groundnut"], #legumes
        cellvalue["begr"] + cellvalue["sugr_cane"] + cellvalue["betr"] + cellvalue["oilpalm"], #plantations
        cellvalue["potato"] + cellvalue["cassav_sp"] + cellvalue["sugr_beet"], #roots
        cellvalue["rapeseed"] + cellvalue["sunflower"] + cellvalue["cottn_pro"], #non-legume oil crops
        rep(cellvalue["fallow"] / 2, 2), #fallow
        rep(cellvalue["foddr"] / 2, 2), #foddr
        rep(cellvalue["others"] / 5, 5) #fruits vegetables nuts
      )
    } else if (groupdiv == "agg3") {
      mix <- c(
        cellvalue["tece"] + cellvalue["maiz"] + cellvalue["trce"] + cellvalue["rice_pro"], #rice
        cellvalue["puls_pro"] + cellvalue["soybean"] + cellvalue["groundnut"], #legumes
        cellvalue["begr"] + cellvalue["sugr_cane"] + cellvalue["betr"] + cellvalue["oilpalm"], #plantations
        cellvalue["potato"] + cellvalue["cassav_sp"] + cellvalue["sugr_beet"] +
          cellvalue["rapeseed"] + cellvalue["sunflower"] + cellvalue["cottn_pro"] + cellvalue["foddr"], #other
        cellvalue["others"], #fruits vegetables nuts
        cellvalue["fallow"] #fallow
      )
    } else {
      mix <- cellvalue
    }

    div <- selectIndex(mix, index)

    return(div)
  }
  x <- magpply(area, FUN = cropdiv, DIM = 3, cropnames = getNames(area))
  if (index == "gini") {
    x[is.na(x)] <- 1
    x[x == Inf] <- 1
  } else {
    x[is.na(x)] <- 0
    x[x == Inf] <- 0
  }

  if (index == "shannon") {
    x <- setNames(x, "Biodiversity|Shannon crop area diversity index (unitless)")
  } else if (index == "invsimpson") {
    x <- setNames(x, "Biodiversity|Inverted Simpson crop area diversity index (unitless)")
  } else if (index == "gini") {
    x <- setNames(x, "Biodiversity|Gini crop area diversity index (unitless)")
  }

  if (index == "shannon") {
    desc <- "Shannon crop area diversity index calculated based on historical FAO country-level crop area"
  } else if (index == "invsimpson") {
    desc <- "Inverted Simpson crop area diversity index based on historical FAO country-level crop area"
  } else if (index == "gini") {
    desc <- "Gini crop area diversity index based on historical FAO country-level crop area"
  }

  out <- dimSums(x * land, dim = c("x", "y")) / dimSums(land, dim = c("x", "y"))
  out <- toolConditionalReplace(x = toolCountryFill(out),
                                conditions = "is.na()", replaceby = 0)
  land <- dimSums(land, dim = c("x", "y"))
  land <- toolConditionalReplace(x = toolCountryFill(land),
                                 conditions = "is.na()", replaceby = 0)

  out <- add_dimension(out, dim = 3.1, add = "scenario",
                       nm = "historical")
  out <- add_dimension(out, dim = 3.2, add = "model",
                       nm = "based_on_ostberg2023")

  return(list(
    x = out,
    weight = land,
    unit = "unitless",
    description = desc
  ))
}
