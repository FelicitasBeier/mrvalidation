# readWBPoverty

read World Bank poverty percentage of population under poverty line, and
gini coef data No download function from WDI API yet, as the older
versions (2011PPP as opposed to 2017PPP online) are currently most
relevant for validating Soergel poverty model results and must be
downloaded manually

## Usage

``` r
readWBPoverty(subtype = "320PovertyLine")
```

## Arguments

- subtype:

  either "Gini", or the three poverty line thresholds: "190PovertyLine",
  "320PovertyLine", "550PovertyLine"

## Value

magclass object

## Author

David M Chen

## Examples

``` r
if (FALSE) { # \dontrun{
readSource("readWBPoverty", subtype = "320PovertyLine")
} # }
```
