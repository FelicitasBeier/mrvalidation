# EmisLucGlo

Read historic land-use change CO2 emissions

## Usage

``` r
readEmisLucGlo(subtype = NULL)
```

## Arguments

- subtype:

  Available subtypes are:

  - historical:

    - Canadell_2007

    - Friedlingstein_2010

    - Harris_2013

    - Houghton_2012

    - RCP

## Value

magpie object containing data land-use change CO2 emissions

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Florian Humpenoeder

## Examples

``` r
if (FALSE) { # \dontrun{ 
a <- readSource("EmisLucGlo",subtype="Canadell_2007")
a <- readSource("EmisLucGlo",subtype="Friedlingstein_2010")
} # }
#'@importFrom reshape2 dcast
```
