# calcValidLivestockDemStructure

calculates the validation data for the share of different livestock
products (excluding fish) in total livestock calorie food supply

## Usage

``` r
calcValidLivestockDemStructure(datasource = "FAO")
```

## Arguments

- datasource:

  Datasource of validation data. If "FAO", we use FAO calories with FAO
  population data (slightly diverges from original data as the convert
  script for example splits up countries for the past).

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcFoodSupplyPast`](https://rdrr.io/pkg/mrcommons/man/calcFoodSupplyPast.html),
[`calcValidLivestockShare`](calcValidLivestockShare.md)

## Author

Isabelle Weindl

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidLivestockDemStructure")
} # }
```
