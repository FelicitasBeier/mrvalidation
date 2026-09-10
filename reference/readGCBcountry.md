# readGCBcountry

Read country-level bookkeeping land-use-change CO2 fluxes for the three
GCB bookkeeping models (BLUE, OSCAR, Houghton & Nassikas) from the
Obermeier et al. (2024) compilation. Net, gross source and gross sink
are read for each model, 1950-2021, in Mt C per year. The bookkeeping
models do not represent peat, so the fluxes are native ex-peatland (net
= source + sink, no peat term).

## Usage

``` r
readGCBcountry()
```

## Value

magpie object (ISO3 x year x model.component), Mt C/yr

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Florian Humpenoeder

## Examples

``` r
if (FALSE) { # \dontrun{
readSource("GCBcountry")
} # }
```
