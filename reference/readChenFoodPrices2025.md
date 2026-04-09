# readChenFoodPrices2025

Read regression coefficients for food price markup and
food-away-from-home share from Chen et al. 2025 Nature Food paper.

## Usage

``` r
readChenFoodPrices2025(subtype = "MarkupCoef")
```

## Arguments

- subtype:

  Either "FafhCoef" for food-away-from-home share coefficients, or
  "MarkupCoef" for the markup coefficients by product and consumption
  type

## Value

magpie object with regression coefficients

## Author

David M Chen

## Examples

``` r
if (FALSE) { # \dontrun{
readSource("ChenFoodPrices2025", subtype = "MarkupCoef")
} # }
```
