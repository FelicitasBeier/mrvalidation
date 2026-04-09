# calcValidLand

Returns historical cropland, pasture and forest area from FAOSTAT that
can be used for model validation.

## Usage

``` r
calcValidLand(datasource = "MAgPIEown")
```

## Arguments

- datasource:

  Currently available: `"FAO"`, `"LUH2v2"`, `"LUH3"`, `"MAgPIEown"` and
  `"SSPResults"`

## Value

list of magpie object with data and weight

## Author

Ulrich Kreidenweis, Benjamin Bodirsky, Abhijeet Mishra, Mishko
Stevanovic, Kristine Karstens
