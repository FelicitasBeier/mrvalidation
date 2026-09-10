# ValidGlobalCarbonBudget

validation for total and cumulative land emissions from the Global
Carbon Budget, including all bookkeeping models

## Usage

``` r
calcValidGlobalCarbonBudget(cumulative = FALSE)
```

## Arguments

- cumulative:

  cumulative from y2000

## Value

a MAgPIE object

## Details

The historical series pooled under
`Emissions|CO2|Land|+|Land-use Change` are all LUC-scale CO2 SOURCES and
are broadly comparable to MAgPIE's `+|Land-use Change`. Verified against
the ingested validation data (not the parent publications), they form a
single positive cloud (Mt CO2/yr, World, 2000-2010): bookkeeping
BLUE/OSCAR/GCB/H&C ~2600-6600 and the national-statistics series
FAO_EmisLUC/EDGAR_LU/PRIMAPhist ~2800-5400 - the latter numerically
indistinguishable from the bookkeeping cloud. They differ mainly on
PEAT; a second, conceptual axis (INDIRECT/Grassi) matters in principle
but is NOT represented in the ingested data (see Axis 2):

|                      |          |                                                    |
|----------------------|----------|----------------------------------------------------|
| **source**           | **peat** | **nature (as ingested)**                           |
| BLUE, OSCAR, H&C2023 | incl     | net has GCB's peat folded in (see PEAT below)      |
| GCB (this fn)        | incl     | published GCB net (own net column, peat folded in) |
| Gasser et al 2020    | excl     | OSCAR bookkeeping (separate fn)                    |
| FAO_EmisLUC          | incl     | FAOSTAT net LULUCF ("Land Use total"), a source    |
| EDGAR_LU             | incl     | EDGAR LULUCF CO2, a source                         |
| PRIMAPhist           | incl     | PRIMAP-hist CAT5 (LUCF) CO2, a source              |

Axis 1 - PEAT. GCB folds a common peat drainage & fires term (~0.7-1.7
Gt CO2/yr) into EVERY bookkeeping model's net, though only GCB's block
breaks it out as a column (verified: each model's net exceeds the sum of
its ex-peat components by exactly that peat). So `+|Land-use Change` is
already consistently incl-peat across all four models, matching MAgPIE's
`+|Land-use Change` (which also includes peat). The function reads GCB's
peat column and adds, for all four models, a matching `...|+|Peatland`
child (closing the net-vs-components gap) and
`...|Land-use Change|Excl Peatland` (net of peat, matching MAgPIE's
peat-excluded line). Gasser and the national-statistics series are
handled elsewhere.

Axis 2 - INDIRECT (Grassi) - NOT represented in the ingested data. In
principle the bookkeeping-vs-NGHGI gap (~5 Gt CO2/yr; Grassi et al.
2021, doi:10.1038/s41558-021-01033-6) arises because country
inventories, reporting the sink-inclusive NET LULUCF over a large
managed-land area, embed the environmental sink and sit far BELOW
bookkeeping ELUC - which would make net `Emissions|CO2|Land` the
matching counterpart. BUT none of the FAO_EmisLUC/EDGAR_LU/PRIMAPhist
series ingested here is that Grassi-adjusted NGHGI net: FAO is FAOSTAT's
net "Land Use total" (its forest sink included but modest, so still a ~4
Gt SOURCE), EDGAR/PRIMAP are LULUCF CO2 series - all positive,
LUC-scale, none carrying a net-flux or Indirect sink series. They must
therefore be compared to MAgPIE's `+|Land-use Change` like the
bookkeeping sources, NOT to net Land. The sink-inclusive NGHGI-net
quantity Grassi contrasts with bookkeeping is absent from this
validation cloud, so MAgPIE's own `+|Indirect` (its Grassi managed-land
sink ~-5.6 Gt CO2/yr, `i52_land_carbon_sink`) has no inventory
counterpart here to validate against.

GCB note - every workbook model's net INCLUDES the common peat drainage
& fires (verified: World 2010, GCB 5181 / BLUE 6156 / OSCAR 5775 / H&C
3612, each = its ex-peat components + ~943 peat). GCB's block is the
only one that lists peat as a separate column. That peat column is now
read and attached as a +\|Peatland child to all four, so net =
components + peat holds and the Excl Peatland variant matches MAgPIE's
line.

Do NOT benchmark net Land against GCB: the only Indirect / net
`Emissions|CO2|Land` series here is GCB's, where Indirect = the GCB
terrestrial sink S_LAND over ALL land (World 2020: -11403 Mt CO2/yr,
~the whole-biosphere sink), NOT the managed-land Grassi quantity MAgPIE
reports.

## Author

Michael Crawford, Florian Humpenoeder

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidGlobalCarbonBudget")
} # }
```
