# calcValidPriceIndex

provides global producer price index from FAO

## Usage

``` r
calcValidPriceIndex(
  datasource = "FAO",
  value = "real",
  baseyear = "y2005",
  round = TRUE
)
```

## Arguments

- datasource:

  Options of the source of data: `FAO`.

- value:

  `real` and `nominal`

- baseyear:

  Baseyear for normalizing of price index.

- round:

  Rounding of price index to intiger numbers. Default `TRUE`.

## Value

List with a magpie object with global nominal and real price index.

## See also

[`readProdPrIndex`](readProdPrIndex.md)

## Author

Mishko Stevanovic

## Examples

``` r
if (FALSE) { # \dontrun{
a <- calcOutput("ValidPriceIndex", value = "real", aggregate = FALSE)
} # }
```
