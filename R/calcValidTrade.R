#' @title calcValidTrade
#' @description calculates the validation data for trade of agricultural products
#'
#' @param datasource Datasource of validation data.
#' @param detail if FALSE, only larger product categories are reported
#' @param nutrient The nutrient in which the results shall be reported.
#' @param net_trade Net trade flows or total trade
#' @param equalized numbers changed so that global production meets global demand
#'  (in reality different because of time-delay between exports and imports)
#'
#' @return List of magpie objects with results on country level, weight on country level, unit and description.
#' @author Benjamin Leon Bodirsky, Xiaoxi Wang, David M Chen
#' @seealso
#' \code{\link[mrcommons]{calcFAOmassbalance}},
#' \code{\link{calcValidDemand}}
#' @examples
#' \dontrun{
#' calcOutput("ValidTrade")
#' }
#'
#' @importFrom magpiesets reporthelper summationhelper findset

calcValidTrade <- function(datasource = "FAO", detail = TRUE, nutrient = "dm",
                           net_trade = TRUE, # nolint: object_name_linter.
                           equalized = FALSE) {

  if (datasource %in% c("FAO", "FAOpre2010", "FAOpost2010")) {

    if (datasource == "FAO") {
      mb <- collapseNames(calcOutput("FAOmassbalance", aggregate = FALSE)[, , nutrient])
    } else if (datasource == "FAOpre2010") {
      mb <- collapseNames(calcOutput("FAOmassbalance",
                                     version = "pre2010",
                                     aggregate = FALSE)[, , nutrient])
    } else if (datasource == "FAOpost2010") {
      mb <- collapseNames(calcOutput("FAOmassbalance",
                                     version = "post2010",
                                     aggregate = FALSE)[, , nutrient])
    } else {
      stop("No data exist for the given datasource!")
    }

    if (net_trade) {
      # exports
      mb <- collapseNames(mb[, , c("production")]) - collapseNames(mb[, , "domestic_supply"])

      ### normalize trade for global production/demand mismatch
      .f <- function(x, weight = NULL) {
        y <- dimSums(x, dim = 1) # net global trade, so demand/supply mismatch
        if (is.null(weight)) { # absolute balanceflow for each country the same
          z <- y / length(getItems(x, dim = 1))
        } else if (weight == "net_trade") { # balanceflow proportional to countries im- or exports
          z <- abs(x) / dimSums(abs(x), dim = 1) * y
          z[is.na(z)] <- 0
        } else {
          stop("no weight exits")
        }
        return(x - z)
      }

      if (equalized) {
        normalizedTrade <- .f(mb)
      } else {
        normalizedTrade <- mb
      }

      out <- reporthelper(x = normalizedTrade, dim = 3.1, level_zero_name = "Trade|Net-Trade",
                          detail = detail, partly = TRUE)
    } else {

      exports <- collapseNames(mb[, , c("export")])
      imports <- collapseNames(mb[, , c("import")])
      netTrade <- collapseNames(mb[, , c("production")]) - collapseNames(mb[, , "domestic_supply"] -
                                                                           collapseNames(mb[, , "stock_variation"]))

      check <- exports - imports - netTrade
      message("inconsistencies in massbalances exist before year 2000")
      if (datasource %in% c("FAO", "FAOpre2010")) {
        checkYears <- c("y2000", "y2005", "y2010")
      } else if (datasource == "FAOpost2010") {
        checkYears <- c("y2010", "y2015", "y2020")
      }
      mismatch <- unique(magclass::where(abs(check[, checkYears, ]) > 0.1)$true$individual[, 3])
      if (length(mismatch > 0)) {
        message(paste(c("larger mismatch between absolute trade and net-trade for the products:", mismatch),
                      collapse = " "))
      }

      if (equalized) {
        stop("no equalized absolute trade implemented yet. You should set equalized to FALSE")
      }

      out1 <- reporthelper(exports, dim = 3.1, level_zero_name = "Trade|Exports", detail = detail, partly = TRUE)
      out2 <- reporthelper(imports, dim = 3.1, level_zero_name = "Trade|Imports", detail = detail, partly = TRUE)
      out <- mbind(out1, out2)
    }
  } else if (datasource == "FAOBilateral") {

    tkcr <- calcOutput("FAOBilateralTrade", aggregate = FALSE,
                       output = "qty", products = "kcr", prodAgg = TRUE, fiveYear = TRUE)
    tkli <- calcOutput("FAOBilateralTrade", aggregate = FALSE,
                       output = "qty", products = "kli", prodAgg = TRUE, fiveYear = TRUE)
    to <- calcOutput("FAOBilateralTrade", aggregate = FALSE,
                     output = "qty", products = "kothers", prodAgg = TRUE, fiveYear = TRUE)

    trade <- mbind(tkcr, tkli, to)
    rm(tkcr, tkli, to)

    imports <- dimSums(trade, dim = 1.2)
    exports <- dimSums(trade, dim = 1.1)

    if (net_trade) {
      net <- exports - imports
      out <- reporthelper(x = net, dim = 3.1, level_zero_name = "Trade|Net-Trade",
                          detail = detail, partly = TRUE)
    } else {
      out1 <- reporthelper(exports, dim = 3.1, level_zero_name = "Trade|Exports excl export balanceflow",
                           detail = detail, partly = TRUE)
      out2 <- reporthelper(imports, dim = 3.1, level_zero_name = "Trade|Imports", detail = detail, partly = TRUE)
      out <- mbind(out1, out2)
    }

    if (nutrient != "dm") {
      attr <- calcOutput("Attributes", aggregate = FALSE)
      out <- out * attr[, , nutrient]
    }
  } else {
    stop("No data exist for the given datasource!")
  }

  out <- summationhelper(out, excludeLevels = 1)
  out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
  out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
  names(dimnames(out))[3] <- "scenario.model.variable"
  if (nutrient == "dm") {
    unit <- "Mt DM/yr"
  } else if (nutrient == "nr") {
    unit <- "Mt Nr/yr"
  } else if (nutrient == "p") {
    unit <- "Mt P/yr"
  } else if (nutrient == "k") {
    unit <- "Mt K/yr"
  } else if (nutrient == "ge") {
    unit <- "PJ/yr"
  } else if (nutrient == "wm") {
    unit <- "Mt WM/yr"
  }
  getNames(out) <- paste0(sub("\\|$", "", getNames(out)), " (", unit, ")")

  return(list(x = out,
              weight = NULL,
              unit = unit,
              description = "Agricultural Trade"))
}
