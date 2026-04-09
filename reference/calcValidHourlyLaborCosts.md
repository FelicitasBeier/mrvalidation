# calcValidHourlyLaborCosts

hourly labor costs in crop+livestock production

## Usage

``` r
calcValidHourlyLaborCosts(
  datasource = "ILO_completed",
  dataVersionILO = "Aug24"
)
```

## Arguments

- datasource:

  Available datasources are:

  - ILO_raw : ILO hourly labor costs data

  - ILO_completed : ILO hourly labor costs data completed with a
    regression with GDP pc MER

  - USDA_FA0_raw : USDA/FAO hourly labor costs data

  - USDA_FA0_completed : USDA/FAO hourly labor costs data completed with
    a regression with GDP pc MER

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
calcOutput("ValidHourlyLaborCosts", datasource = "ILO_completed")
} # }
```
