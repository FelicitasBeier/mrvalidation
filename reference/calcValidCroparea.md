# calcValidCroparea

Returns historical areas of individual crops, meant to be used for model
validation. The default source is the madrat croparea preprocessing,
which harmonises LandInG against LUH and calibrates it to
LanduseInitialisation cropland; it is no longer FAOSTAT, so the series
is labelled accordingly rather than as "FAO". Ostberg2023 is a slightly
modified version of
https://gmd.copernicus.org/articles/16/3375/2023/gmd-16-3375-2023-assets.html

## Usage

``` r
calcValidCroparea(datasource = "MadratLandInGLUH", detail = FALSE)
```

## Arguments

- datasource:

  "MadratLandInGLUH": cropland, croparea and fallow as returned by
  calcCroparea (default datasource "LandInG"), i.e. LandInG harmonised
  against LUH and calibrated to LanduseInitialisation cropland
  "ostberg2023": croparea according to LandInG data harmonization by
  Ostberg et al. (2023), uncorrected "FAOfallow": fallow land according
  to FAOSTAT

- detail:

  TRUE: data provided for different crop types, FALSE: aggregated data

## Value

magpie object

## Author

Benjamin Bodirsky, Ulrich Kreidenweis, Felicitas Beier
