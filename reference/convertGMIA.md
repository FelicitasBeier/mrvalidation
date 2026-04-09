# convertGMIA

Convert Global Map on Irrigated Area Data

Convert subtypes on ISO country level.

## Usage

``` r
convertGMIA(x, subtype)
```

## Arguments

- x:

  MAgPIE object containing IrrigatedArea data on Country level

- subtype:

  : No subtype needed

## Value

Global Map on Irrigation data as MAgPIE object on country level Missing
values are added as NA

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Stephen Wirth

## Examples

``` r
if (FALSE) { # \dontrun{
a <- readSource("GlobalIrrigationMap", "all_data_national")
a <- readSource ("GMIA", "aei_pct", convert = FALSE)
a <- readSource ("GMIA", "aei_pct", convert = "correctonly")
} # }
```
