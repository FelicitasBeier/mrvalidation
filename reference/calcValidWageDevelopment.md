# calcValidWageDevelopment

wage index: hourly labor costs in crop+livestock production relative to
a baseyear

## Usage

``` r
calcValidWageDevelopment(
  datasource = "ILO_completed",
  baseYear = 2000,
  dataVersionILO = "Aug24"
)
```

## Arguments

- datasource:

  Available datasources are:

  - ILO_raw : based on ILO hourly labor costs data

  - ILO_completed : based on ILO hourly labor costs data completed with
    a regression with GDP pc MER

  - USDA_FA0_raw : based on USDA/FAO hourly labor costs data

  - USDA_FA0_completed : based on USDA/FAO hourly labor costs data
    completed with a regression with GDP pc MER

- baseYear:

  year relative to which the wage development should be calculated

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
calcOutput("ValidWageDevelopment", datasource = "ILO_completed")
} # }
```
