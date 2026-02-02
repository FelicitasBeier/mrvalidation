#' @title readChenFoodPrices2025
#' @description Read regression coefficients for food price markup and food-away-from-home share
#' from Chen et al. 2025 Nature Food paper.
#'
#' @param subtype Either "FafhCoef" for food-away-from-home share coefficients,
#' or "MarkupCoef" for the markup coefficients by product and consumption type
#'
#' @return magpie object with regression coefficients
#' @author David M Chen
#'
#' @examples
#' \dontrun{
#' readSource("ChenFoodPrices2025", subtype = "MarkupCoef")
#' }
#'
#' @importFrom utils read.csv

readChenFoodPrices2025 <- function(subtype = "MarkupCoef") {

  files <- c(
    "FafhCoef" = "FafhCoef.csv",
    "MarkupCoef" = "MarkupCoef.csv"
  )

  file <- toolSubtypeSelect(subtype, files)

  if (subtype == "FafhCoef") {
    # FafhCoef has format: coefficient_name, value (with header comment line)
    d <- read.csv(file, header = FALSE, comment.char = "*")
    colnames(d) <- c("coef", "value")
    out <- as.magpie(d, spatial = NULL, temporal = NULL, tidy = TRUE)

  } else if (subtype == "MarkupCoef") {
    # MarkupCoef has format: product, fah/fafh type, a, b, c coefficients (with header comment line)
    d <- read.csv(file, header = TRUE, comment.char = "*")
    colnames(d) <- c("product", "type", "a", "b", "c")

    # Convert to long format for magpie
    dLong <- tidyr::pivot_longer(d, cols = c("a", "b", "c"), names_to = "coef", values_to = "value")
    out <- as.magpie(dLong, spatial = NULL, temporal = NULL, tidy = TRUE)

  } else {
    stop("Invalid subtype. Use 'FafhCoef' or 'MarkupCoef'.")
  }

  return(out)
}
