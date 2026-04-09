# ValidEmissionsAFOLU

validation for total and cumulative AFOLU emissions in CO2eq

## Usage

``` r
calcValidEmissionsAFOLU(datasource = "FAO", cumulative = FALSE)
```

## Arguments

- datasource:

  current options are "FAO" and "EDGAR_LU"

- cumulative:

  cumulative from y2000

## Value

MAgPIE object with emissions in CO2eq

## Author

Michael Crawford

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidEmissionsAFOLU")
} # }
```
