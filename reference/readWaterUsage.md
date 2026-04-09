# readWaterUsage

Read Historic and projcted Agricultural water consumption

## Usage

``` r
readWaterUsage(subtype = NULL)
```

## Arguments

- subtype:

  Available subtypes are:

  - historical:

    - foley_2011

    - shiklomanov_2000

    - wada_2011

    - wisser_2008

  - projections

    - fischer_IIASA

    - hejazi_2013

    - molden_IWMI

    - seckler_IWMI

    - shiklomanov

    - aquastat_2008_12

## Value

magpie object containing data on water usage

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Stephen Wirth

## Examples

``` r
if (FALSE) { # \dontrun{
a <- readSource("foley_2011")
a <- readSource("aquastat_2008_12")
} # }
#' @importFrom reshape2 dcast
```
