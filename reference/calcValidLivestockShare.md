# calcValidLivestockShare

calculates the validation data for the share of livestock products
(including fish) in total calorie food supply

## Usage

``` r
calcValidLivestockShare(datasource = "FAO")
```

## Arguments

- datasource:

  Datasource of validation data. If "FAO", we use FAO calories with FAO
  population data (slightly diverges from original data as the convert
  script for example splits up countries for the past). In the case of
  "PopulationPast", we also use FAO calorie values, but divide them by
  our standard population

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcFoodSupplyPast`](https://rdrr.io/pkg/mrcommons/man/calcFoodSupplyPast.html),
[`calcValidKcal`](calcValidKcal.md)

## Author

Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidLivestockShare")
} # }
```
