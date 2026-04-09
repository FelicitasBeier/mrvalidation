# convertIMPACTIrrigInvCosts

converts units and dimensions of average annual baseline water-related
investment cost data from readIMPACTIrrigInvCosts

## Usage

``` r
convertIMPACTIrrigInvCosts(x)
```

## Arguments

- x:

  MAgPIE object containing irrigation investment cost data on region
  level

## Value

magpie object containing average annual baseline water-related
investment cost on country-level (in million 2017 USD per year)

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Felicitas Beier

## Examples

``` r
if (FALSE) { # \dontrun{
a <- readSource("IMPACTIrrigInvCosts", convert = TRUE)
} # }
```
