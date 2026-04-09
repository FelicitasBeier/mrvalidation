# calcValidNitrogenBudgetPasture

Validation Script for Nitrogen Budgets on Pastures

## Usage

``` r
calcValidNitrogenBudgetPasture(datasource = "Bodirsky")
```

## Arguments

- datasource:

  Bodirsky for own calculations, Lassaletta2014 for a country dataset
  from Lassaletta, L., G. Billen, B. Grizzetti, J. Angalde, and J.
  Garnier. 2014. 50 Year Trends in Nitrogen Use Efficiency of World
  Cropping Systems: The Relationship between Yield and Nitrogen Input to
  Pasture. Environmental Research Letters. FAO for some N related
  parameters published in FAOSTAT.

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcNitrogenBudgetCropland`](https://rdrr.io/pkg/mrcommons/man/calcNitrogenBudgetCropland.html)

## Author

Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{ 
calcOutput("ValidNitrogenBudgetPasture")
} # }
```
