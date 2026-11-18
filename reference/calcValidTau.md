# calcValidTau

Returns historical land use intensity estimates (tau).

## Usage

``` r
calcValidTau(datasource = "FAO2012")
```

## Arguments

- datasource:

  Currently available: `"FAO2012"` (original data set), `"FAOonline"`
  (projection of tau values from 1995 based on recent FAO yield
  projections) and `"MadratLandInGFAOLUH"` (projection from 1995 based
  on the calcValidYield series, i.e. FAO production over LandInG
  croparea).

## Value

tau time series

## Author

Jan Philipp Dietrich
