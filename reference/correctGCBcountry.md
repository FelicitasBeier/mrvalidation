# correctGCBcountry

Set the structural NAs from the net-vs-gross country-coverage mismatch
to zero. A few countries are reported in only one of the two source
files (e.g. net but no gross split); an unreported flux contributes zero
to a regional sum. Values already reported are left untouched.

## Usage

``` r
correctGCBcountry(x)
```

## Arguments

- x:

  magpie object returned by readGCBcountry

## Value

magpie object without NAs

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Florian Humpenoeder
