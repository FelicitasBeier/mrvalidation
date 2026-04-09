# calcValidTrade

calculates the validation data for trade of agricultural products

## Usage

``` r
calcValidTrade(
  datasource = "FAO",
  detail = TRUE,
  nutrient = "dm",
  net_trade = TRUE,
  equalized = FALSE
)
```

## Arguments

- datasource:

  Datasource of validation data.

- detail:

  if FALSE, only larger product categories are reported

- nutrient:

  The nutrient in which the results shall be reported.

- net_trade:

  Net trade flows or total trade

- equalized:

  numbers changed so that global production meets global demand (in
  reality different because of time-delay between exports and imports)

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcFAOmassbalance`](https://rdrr.io/pkg/mrcommons/man/calcFAOmassbalance.html),
[`calcValidDemand`](calcValidDemand.md)

## Author

Benjamin Leon Bodirsky, Xiaoxi Wang, David M Chen

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidTrade")
} # }
```
