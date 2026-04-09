# readPardeyAgRD

Agricultural R&D investment data read from
https://www.nature.com/news/agricultural-rd-is-on-the-move-1.20571 3
tables are read in: AgRD_Pardey is public Ag expenditure in 1960 and
2011, extracted from the interactive figure in the article that has more
complete countries agGERD and agPERD are total and public expenditures
respectively, for less countries but more years

## Usage

``` r
readPardeyAgRD()
```

## Value

magpie object containing expenditure in Ag R&D, 2009 USD PPP

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

David Chen

## Examples

``` r
if (FALSE) { # \dontrun{
a <- readSource("PardeyAgRD")
} # }
```
