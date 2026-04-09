# calcValidProduction

calculates the validation data for production of agricultural products

## Usage

``` r
calcValidProduction(datasource = "FAO", detail = TRUE, nutrient = "dm")
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

[`calcFAOmassbalance`](https://rdrr.io/pkg/mrcommons/man/calcFAOmassbalance.html),
[`calcValidDemand`](calcValidDemand.md)

## Author

Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidProduction")
} # }
```
