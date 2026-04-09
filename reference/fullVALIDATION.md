# fullValidation

Function that produces the complete validation data set used for
evaluation of MAgPIE outputs

## Usage

``` r
fullVALIDATION(rev = 0.1, aggregate = "region+global")
```

## Arguments

- rev:

  data revision which should be used as input. Will be converted to
  [`numeric_version`](https://rdrr.io/r/base/numeric_version.html) when
  called via
  [`retrieveData`](https://rdrr.io/pkg/madrat/man/retrieveData.html).

- aggregate:

  an aggregation level, such as "region+global", to be used for all
  outputs that are being aggregated.

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html),[`getCalculations`](https://rdrr.io/pkg/madrat/man/getCalculations.html),[`calcOutput`](https://rdrr.io/pkg/madrat/man/calcOutput.html)

## Author

Jan Philipp Dietrich, Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{
retrieveData("Validation")
} # }
```
