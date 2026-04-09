# calcValidSelfsuff

Validates self-sufficiency ration

## Usage

``` r
calcValidSelfsuff(datasource = "FAO", detail = TRUE)
```

## Arguments

- datasource:

  Options of the source of data: `FAO, FAOpre2010, FAOpost2010`.

- detail:

  Default is `TRU`. If `FALSE`, the subcategories of groups are not
  reported (e.g. "soybean" within "oilcrops")

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## Author

Benjamin Leon Bodirsky, Mishko Stevanovic

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidSelfsuff")
} # }
```
