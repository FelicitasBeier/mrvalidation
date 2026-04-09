# calcValidTotalLaborCosts

total labor costs in crop and livestock production

## Usage

``` r
calcValidTotalLaborCosts(datasource = "USDA", dataVersionILO = "Aug24")
```

## Arguments

- datasource:

  "USDA" (which uses FAO VoP and USDA cost shares) or "ILO" (which is
  based on ILO datasets and calibrated to the USDA/FAO approach, but
  includes costs for some countries without VoP data) or "GTAP"

- dataVersionILO:

  "" for the oldest version, or "monthYear" (e.g. "Aug23") for a newer
  version

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## Author

Debbora Leip

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidTotalLaborCosts", datasource = "USDA")
} # }
```
