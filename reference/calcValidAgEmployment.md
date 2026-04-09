# calcValidAgEmployment

number of people employed in agriculture (crop+livestock production)

## Usage

``` r
calcValidAgEmployment(datasource = "ILO", dataVersionILO = "Aug24")
```

## Arguments

- datasource:

  ILO for reporting aggregated employment in crop+livestock production,
  or ILO_FAO, which uses the same aggregated employment data from ILO,
  but applies FAO value of production shares to disaggregated between
  employment in crop and in livestock production.

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
calcOutput("ValidAgEmployment", datasource="ILO")
} # }
```
