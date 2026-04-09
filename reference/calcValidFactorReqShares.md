# calcValidFactorReqShares

calculates the validation data for labor and capital requirement shares
in agriculture (currently the same shares for crop and livestock
production based on USDA data)

## Usage

``` r
calcValidFactorReqShares(subtype = "crop")
```

## Arguments

- subtype:

  for which to report requirement shares, either "crop" or "livestock"

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## Author

Debbora Leip

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidFactorReqShares")
} # }
```
