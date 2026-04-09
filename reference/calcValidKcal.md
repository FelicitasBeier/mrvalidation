# calcValidKcal

calculates the validation data for calorie food supply

## Usage

``` r
calcValidKcal(datasource = "FAO", nutrient = "kcal", detail = TRUE)
```

## Arguments

- datasource:

  Datasource of validation data. If "FAO", we use FAO calories with FAO
  population data (slightly diverges from original data as the convert
  script for example splits up countries for the past). If
  "FAOmassbalance" we use calories from the FAO massbalance
  calculations, and divide them by our standard population.

- nutrient:

  kcal or protein

- detail:

  if FALSE, only larger product categories are reported

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcFoodSupplyPast`](https://rdrr.io/pkg/mrcommons/man/calcFoodSupplyPast.html),
[`calcValidLivestockShare`](calcValidLivestockShare.md)

## Author

Benjamin Leon Bodirsky, Kristine Karstens

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidKcal")
} # }
```
