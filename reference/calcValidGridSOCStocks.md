# calcValidGridSOCStocks

calculates the validation data for the gridded soil carbon pools

## Usage

``` r
calcValidGridSOCStocks(
  datasource = "LPJ_IPCC2006",
  baseyear = 1995,
  intensive = FALSE
)
```

## Arguments

- datasource:

  Datasources for validation data, e.g. LPJ_IPCC2006, LPJmL_natural, ...

- baseyear:

  baseyear for calculating soil carbon stock change (for LPJ_IPCC2006
  only)

- intensive:

  If FALSE (default) total stocks will be returned; otherwise (TRUE)
  carbon densities.

## Value

List of magpie objects with results on cellular level, weight on
cellular level, unit and description.

## Author

Kristine Karstens

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidGridSOCStocks")
} # }
```
