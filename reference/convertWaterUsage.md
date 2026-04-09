# convertWaterUsage

Convert data on agricultural water use Convert subtypes on ISO country
level.

## Usage

``` r
convertWaterUsage(x, subtype)
```

## Arguments

- x:

  MAgPIE object containing IrrigatedArea data on Country level

- subtype:

  : No subtype needed

## Value

Data on water use as MAgPIE object on country level Missing values are
added as NA

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Stephen Wirth

## Examples

``` r
if (FALSE) { # \dontrun{
a <- readSource("WaterUsage", "aquastat_2008_12")
} # }
```
