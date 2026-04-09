# convertHID

Convert subtypes on ISO country level.

## Usage

``` r
convertHID(x, subtype)
```

## Arguments

- x:

  MAgPIE object containing IrrigatedArea data on Country level

- subtype:

  : No subtype needed

## Value

Irrigated Area data as MAgPIE object on country level Missing values are
added as NA

## Details

Convert Historic Irrigation Data

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Stephen Wirth

## Examples

``` r
if (FALSE) { # \dontrun{
a <- readSource("HID", "national_1900_2005")
} # }
```
