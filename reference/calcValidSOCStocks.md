# calcValidSOCStocks

calculates the validation data for the soil carbon pools

## Usage

``` r
calcValidSOCStocks(datasource = "histSOCbudget", baseyear = 1995)
```

## Arguments

- datasource:

  Datasources for validation data, e.g. LPJ_IPCC2006, LPJmL_natural

- baseyear:

  baseyear for calculating soil carbon stock change

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcFoodSupplyPast`](https://rdrr.io/pkg/mrcommons/man/calcFoodSupplyPast.html),
[`calcValidLivestockShare`](calcValidLivestockShare.md)

## Author

Benjamin Leon Bodirsky, Kristine Karstens

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidSOCStocks")
} # }
```
