# calcValidLandChange

Returns historical changes of cropland, pasture and forest area from
LUH2 and FAOSTAT that can be used for model validation.

## Usage

``` r
calcValidLandChange(baseyear = 1995, datasource = "MAgPIEown")
```

## Arguments

- baseyear:

  baseyear for calculating land-use change

- datasource:

  Currently available: `"FAO"`, `"LUH2v2"`, `"LUH3"`, `"MAgPIEown"` and
  `"SSPResults"`

## Value

list of magpie object with data and weight

## Author

Florian Humpenoeder
