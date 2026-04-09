# calcValidYield

Calculates a dataset of agricultural production out of the combined data
of calcFAOharmonized(). Covers dry matter (DM) production. Also returns
areas of individual crops from FAOSTAT. Total area can be lower or
higher than arable land because of multicropping or fallow land. Returns
yield as calculated from area area and production.

## Usage

``` r
calcValidYield(
  datasource = "FAO",
  faoVersion = "join2010",
  future = NULL,
  physical = TRUE
)
```

## Arguments

- datasource:

  Specify which datasource needs to be used. Currently only "FAO" and
  "calibratedLPJmL" is available.

- faoVersion:

  which FAO version to use (pre, post or joined 2010 data)

- future:

  if NULL no future values are returned (default). specify climate
  scenario (gcm:rcp), if future is needed

- physical:

  if true (default) physical area (croparea) used for yield calculation;
  if false harvested area used for yield calculation

## Value

List of magpie objects with results on country level, weight on country
level, unit, Max.&Min. values alongwith description.

## See also

[`calcFAOmassbalance`](https://rdrr.io/pkg/mrcommons/man/calcFAOmassbalance.html),
[`calcCroparea`](https://rdrr.io/pkg/mrlandcore/man/calcCroparea.html)

## Author

Abhijeet Mishra, Isabelle Weindl, Florian Humpenoeder

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidYield")
} # }
```
