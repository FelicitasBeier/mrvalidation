# calcValidCroparea

Returns historical areas of individual crops. These are derived by
correcting harvested areas to match to physical cropland areas. Both
these datasets are from FAO. Output is meant to be used for model
validation. Ostberg2023 is a slightly modified version of
https://gmd.copernicus.org/articles/16/3375/2023/gmd-16-3375-2023-assets.html

## Usage

``` r
calcValidCroparea(datasource = "FAO", detail = FALSE)
```

## Arguments

- datasource:

  Currently only "FAO" available

- detail:

  how much detail?

## Value

list of magpie object with data and weight

## Author

Benjamin Bodirsky, Ulrich Kreidenweis
