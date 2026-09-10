# calcValidGCBcountry

Regional bookkeeping land-use-change CO2 validation band (BLUE, OSCAR,
Houghton & Nassikas) from the Obermeier et al. (2024) country-level
compilation. It gives every region a bookkeeping band where previously
only Gasser (OSCAR) existed regionally and the GCB workbook ensemble was
World-only.

## Usage

``` r
calcValidGCBcountry()
```

## Value

list with a magpie object (Mt CO2/yr) and metadata

## Details

The three bookkeeping models are native ex-peatland (they do not
represent peat), so the net flux is reported as
`Emissions|CO2|Land|Land-use Change|Excl Peatland` - the like-for-like
counterpart to MAgPIE's Excl-Peatland line and to the ex-peat Gasser
band (see [`calcValidEmisLucGasser`](calcValidEmisLucGasser.md)). Gross
source and sink are reported as `...|Land-use Change|Gross Positive` /
`Gross Negative`, matching the magpie4 LUC-CO2 memos (net = Gross
Positive + Gross Negative). Returned at ISO level with weight NULL so
`calcOutput` sums to the requested regions; `fullVALIDATION` requests
regions only, since the World bookkeeping cloud is already covered by
[`calcValidGlobalCarbonBudget`](calcValidGlobalCarbonBudget.md).

## See also

[`calcValidEmisLucGasser`](calcValidEmisLucGasser.md),
[`calcValidGlobalCarbonBudget`](calcValidGlobalCarbonBudget.md)

## Author

Florian Humpenoeder
