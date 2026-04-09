# calcValidManure

Validates the esitmates on excretion and manure management

## Usage

``` r
calcValidManure(datasource = "Bodirsky")
```

## Arguments

- datasource:

  own: own estimation for the past based on feed intake, IPCC: standard
  excretion factors, FAO: FAO estimates

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcExcretion`](https://rdrr.io/pkg/mrcommons/man/calcExcretion.html),
[`calcExcretionIPCC`](https://rdrr.io/pkg/mrcommons/man/calcExcretionIPCC.html)

## Author

Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidManure")
} # }
```
