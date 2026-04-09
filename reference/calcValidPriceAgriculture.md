# calcValidPriceAgriculture

provides global prices from the IMPACT model projections, World Bank
observations, and FAO obersvations for MAgPIE commodities in \$2017/tDM

## Usage

``` r
calcValidPriceAgriculture(datasource = "FAO")
```

## Arguments

- datasource:

  Options of the source of data: `IMPACT3.2.2World_Price`, `FAO`, `FAOp`
  and `WBGEM`.

## Value

List with a magpie object with commodity prices on global and country
level.

## See also

[`readIMPACT3.2.2World_Price`](https://rdrr.io/pkg/mrcommons/man/readIMPACT3.2.2World_Price.html)

## Author

Mishko Stevanovic

## Examples

``` r
if (FALSE) { # \dontrun{ 
calcOutput("ValidPriceAgriculture", datasource="IMPACT3.2.2World_Price", aggregate=FALSE)
calcOutput("ValidPriceAgriculture", datasource="FAO")
} # }
```
