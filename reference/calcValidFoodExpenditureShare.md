# calcValidFoodExpenditureShare

validation for food expenditure share

## Usage

``` r
calcValidFoodExpenditureShare(detail = FALSE, expenditureType = "agPrimary")
```

## Arguments

- detail:

  if FALSE, only major food commoditiy groups are shown.

- expenditureType:

  Either "agPrimary" for agricultural primary products share, or "food"
  for total food expenditure share including value-added marketing
  margins

## Value

List of magpie object with results on country level, weight on country
level, unit and description.

## Author

Benjamin Leon Bodirsky, David M Chen

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidFoodExpenditureShare")
} # }
```
