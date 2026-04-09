# calcValidPovertyLine

Validation of poverty (head-count)

## Usage

``` r
calcValidPovertyLine(datasource = "WBPoverty", subtype = "320PovertyLine")
```

## Arguments

- datasource:

  datasource for validation. Option: "WBPoverty" (world bank).

- subtype:

  Poverty line criteria. Options:"320PovertyLine" (default),
  "550PovertyLine", "1p90 USDppp11/day"

## Value

List of magpie object with results on country level, no weight, unit and
description.

## Author

Edna J. Molina Bacca

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidPovertyLine")
} # }
```
