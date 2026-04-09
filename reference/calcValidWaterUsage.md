# calcValidWaterUsage

Returns historical and projected water withdrawal from different data
sources

## Usage

``` r
calcValidWaterUsage(datasource = "shiklomanov_2000")
```

## Arguments

- datasource:

  Currently available:

  - historical:

    - `"foley_2011"`

    - `"shiklomanov_2000"`

    - `"wada_2011"`

    - `"wisser_2008"`

    - `"CWatM:ipsl-cm5a-lr"`

    - `"CWatM:gfdl-esm2m"`

    - `"CWatM:miroc5"`

    - `"CWatM:hadgem2-es"`

    - `"LPJmL:ipsl-cm5a-lr"`

    - `"LPJmL:gfdl-esm2m"`

    - `"LPJmL:miroc5"`

    - `"LPJmL:hadgem2-es"`

    - `"H08:ipsl-cm5a-lr"`

    - `"H08:gfdl-esm2m"`

    - `"H08:miroc5"`

    - `"H08:hadgem2-es"`

    - `"MATSIRO:ipsl-cm5a-lr"`

    - `"MATSIRO:gfdl-esm2m"`

    - `"MATSIRO:miroc5"`

    - `"MATSIRO:hadgem2-es"`

    - `"MPI-HM:ipsl-cm5a-lr"`

    - `"MPI-HM:gfdl-esm2m"`

    - `"MPI-HM:miroc5"`

    - `"PCR-GLOBWB:ipsl-cm5a-lr"`

    - `"PCR-GLOBWB:gfdl-esm2m"`

    - `"PCR-GLOBWB:miroc5"`

    - `"PCR-GLOBWB:hadgem2-es"`

  - projections:

    - `"fischer_IIASA"`

    - `"hejazi_2013"`

    - `molden_IWMI`

    - `seckler_IWMI`

    - `shiklomanov`

## Value

list of magpie object, weight, unit, and description

## Author

Stephen Wirth, Anne Biewald, Felicitas Beier
