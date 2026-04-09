# calcValidFoodExpenditure

validation for food expenditure

## Usage

``` r
calcValidFoodExpenditure(
  detail = FALSE,
  datasource = "FAO",
  expenditureType = "agPrimary"
)
```

## Arguments

- detail:

  if FALSE, only major food commoditiy groups are shown.

- datasource:

  Datasource for demand (FAO, FAOpre2010, FAOpost2010)

- expenditureType:

  Either "agPrimary" for agricultural primary products (demand \*
  prices), or "food" for total food expenditure including value-added
  marketing margins based on Chen et al. 2025 regression coefficients

## Value

List of magpie object with results on country level, weight on country
level, unit and description.

## Author

Benjamin Leon Bodirsky, David M Chen

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidFoodExpenditure")
} # }
```
