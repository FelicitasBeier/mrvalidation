# calcValidSOCDensity

calculates the validation data for the soil carbon densities (including
weights for aggregation)

## Usage

``` r
calcValidSOCDensity(datasource = "GSOC")
```

## Arguments

- datasource:

  Datasources for validation data

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcSOM`](https://rdrr.io/pkg/mrcommons/man/calcSOM.html)
[`calcValidSOCStocks`](calcValidSOCStocks.md)

## Author

Kristine Karstens

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidSOCDensity")
} # }
```
