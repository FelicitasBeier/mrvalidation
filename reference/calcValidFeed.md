# calcValidFeed

calculates the validation data for feed demand by animal type

## Usage

``` r
calcValidFeed(datasource = "FAO", detail = TRUE, nutrient = "dm")
```

## Arguments

- datasource:

  Datasource of validation data.

- detail:

  if FALSE, only larger product categories are reported

- nutrient:

  The nutrient in which the results shall be reported.

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcFoodSupplyPast`](https://rdrr.io/pkg/mrcommons/man/calcFoodSupplyPast.html),
[`calcValidLivestockShare`](calcValidLivestockShare.md)

## Author

Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidFeed")
} # }
```
