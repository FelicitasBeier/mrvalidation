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

  "FAO": croparea according to FAOSTAT, "ostberg2023": croparea
  according to LandInG data harmonization by Ostberg et al. (2023)
  "FAOfallow": fallow land according to FAOSTAT

- detail:

  TRUE: data provided for different crop types, FALSE: aggregated data

## Value

magpie object

## Author

Benjamin Bodirsky, Ulrich Kreidenweis, Felicitas Beier
