# calcValidFeedConversion

calculates various feed indicators

## Usage

``` r
calcValidFeedConversion(livestockSystem = TRUE, subtractBalanceflow = FALSE)
```

## Arguments

- livestockSystem:

  if TRUE, ruminant meat and milk are aggregated, and poultry meat and
  egg are aggregated

- subtractBalanceflow:

  if TRUE, balanceflow is subtracted so that the feed conversion
  reflects our feedbasket calucaltions. If FALSE, it reflects the FAO
  values and the pasture demand

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcFoodSupplyPast`](https://rdrr.io/pkg/mrcommons/man/calcFoodSupplyPast.html),
[`calcValidLivestockShare`](calcValidLivestockShare.md)

## Author

Benjamin Leon Bodirsky, github Copilot

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidFeed")
} # }
```
