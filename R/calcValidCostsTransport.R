#' @title calcValidCostsTransport
#' @description calculates the validation data for transport costs
#'
#' @param datasource Datasource of validation data
#' @return List of magpie objects with results on country level, weight on country level, unit and description.
#' @author David Chen
#' @examples
#' \dontrun{
#' calcOutput("ValidCostsTransport")
#' }
#'
#' @import mrmagpie

#' @importFrom magpiesets reporthelper summationhelper reportingnames
calcValidCostsTransport <- function(datasource = "GTAPtransport") {

  if (datasource %in% c("GTAPtransport", "GTAPwholesale")) {
    if (datasource == "GTAPtransport") {
      costType <- "transport"
    } else {
      costType <- "wholesale"
    }

    transportGtap <- calcOutput("GTAPTotalTransportCosts", costType = costType,
                                aggregate = FALSE)

    # re-do some of calcTransportCosts, but add processed products, and only take totals

    # map gtap cfts to MAgPIE cfts
    cftRel <- list()
    cftRel[["pdr"]] <- c("rice_pro")
    cftRel[["wht"]] <- c("tece")
    cftRel[["gro"]] <- c("maiz", "trce", "begr", "betr")
    cftRel[["v_f"]] <- c("others", "potato", "cassav_sp", "puls_pro")
    cftRel[["osd"]] <- c("soybean", "oilpalm", "rapeseed", "sunflower", "groundnut")
    cftRel[["c_b"]] <- c("sugr_beet", "sugr_cane")
    cftRel[["ocr"]] <- c("foddr")
    cftRel[["rmk"]] <- "livst_milk"
    cftRel[["ctl"]] <- c("livst_rum")
    cftRel[["oap"]] <- c("livst_chick", "livst_egg", "livst_pig")
    cftRel[["pfb"]] <- c("fibres")
    cftRel[["sgr"]] <- c("sugar")
    cftRel[["vol"]] <- c("oils")
    cftRel[["b_t"]] <- c("alcohol")

    # add processed rice, cattle meat, dairy products, and other meats to their raw eq's, and remove
    transportGtap[, , "pdr"] <- transportGtap[, , "pdr"] + setNames(transportGtap[, , "pcr"], NULL)
    transportGtap[, , "ctl"] <- transportGtap[, , "ctl"] + setNames(transportGtap[, , "cmt"], NULL)
    transportGtap[, , "rmk"] <- transportGtap[, , "rmk"] + setNames(transportGtap[, , "mil"], NULL)
    transportGtap[, , "oap"] <- transportGtap[, , "oap"] + setNames(transportGtap[, , "omt"], NULL)

    rm <- c("pcr", "mil", "cmt", "omt")

    transportGtap <- transportGtap[, , rm, invert = TRUE]

    # use production ratios to split along product categories

    prod <- collapseNames(calcOutput("FAOmassbalance", aggregate = FALSE)[, , "production"][, ,
                                                                                            "dm"])
    prod <- time_interpolate(prod, interpolated_year = c(2000:2011),
                             integrate_interpolated_years = TRUE)

    out <- new.magpie(cells_and_regions = getItems(transportGtap, dim = 1),
                      years = getYears(transportGtap),
                      unlist(cftRel))


    ## split the combined products by production ratio
    for (i in seq_along(cftRel)) {
      out[, , cftRel[[i]]] <- collapseNames(transportGtap[, , names(cftRel)[[i]]]) *
        (prod[, getYears(out), cftRel[[i]]] /
           ifelse(dimSums(prod[, getYears(out), cftRel[[i]]], dim = 3) > 0,
                  dimSums(prod[, getYears(out), cftRel[[i]]], dim = 3),
                  length(cftRel[[i]]) / 1))

    }

    if (costType == "transport") {
      lzname <- "Costs|Transport"
      description <- "Transport Costs"
    } else {

      lzname <- "Costs|Wholesale Costs"
      description <- "Wholesale Costs"
    }

    out <- reporthelper(out, level_zero_name = lzname, partly = TRUE, detail = FALSE)
    out <- summationhelper(out, excludeLevels = 2)

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)

    getNames(out) <- paste(getNames(out), "(million US$2017/yr)", sep = " ")
    unit <- "million US$2017/yr"

  } else if (datasource == "MAgPIEcalc") {

    distance <- calcOutput("TransportTime", aggregate = FALSE)
    productionKcr <- calcOutput("Production", cellular = TRUE,
                                products = "kcr", attributes = "dm", aggregate = FALSE)
    productionKli <- calcOutput("Production", cellular = TRUE,
                                products = "kli", attributes = "dm", aggregate = FALSE)
    productionPasture <- calcOutput("Production", cellular = TRUE,
                                    products = "pasture", attributes = "dm", aggregate = FALSE)
    productionPasture <- add_dimension(productionPasture, add = "pasture",
                                       nm = "pasture", dim = 3.1)
    production <- mbind(productionKcr, productionKli, productionPasture)

    productionDistance <- collapseNames(distance * production, collapsedim = 2)

    # costs per unit per distance
    costs <- readSource("TransportCostsGTAP", convert = FALSE)

    products <- intersect(getNames(productionDistance), getNames(costs))

    # total costs
    out <- costs[, , products] * productionDistance[, , products]

    # aggregate to country-level
    out <- dimSums(out, dim = c(1.1, 1.2))
    out <- toolCountryFill(out, fill = 0)

    # add missing product groups, so that report and summation helper work properly.
    # Note that forest, secondary, fish, bioenergy and  residues set to 0 currently
    missingProducts <- setdiff(findset("kall"), products)
    out <- add_columns(out, addnm = missingProducts, dim = 3.1)
    out[, , missingProducts] <- 0

    out <- reporthelper(out, dim = 3.1, level_zero_name = "Costs|Transport", partly = TRUE,
                        detail = FALSE)
    out <- summationhelper(out)

    getNames(out) <- paste(getNames(out), "(million US$2017/yr)", sep = " ")
    unit <- "million US$17/yr"

    out <- add_dimension(out, dim = 3.1, add = "scenario", nm = "historical")
    out <- add_dimension(out, dim = 3.2, add = "model", nm = datasource)
    description <- "Transport Costs"


  } else {
    stop("Only own calculation and GTAP transport costs avilable currently!")
  }

  return(list(x = out,
              weight = NULL,
              unit = unit,
              description = description)
  )
}
