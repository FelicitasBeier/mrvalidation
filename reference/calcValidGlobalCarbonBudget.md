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

|                      |          |                                                 |
|----------------------|----------|-------------------------------------------------|
| **source**           | **peat** | **nature (as ingested)**                        |
| BLUE, OSCAR, H&C2023 | excl     | bookkeeping ELUC (direct, ex-peat)              |
| GCB (this fn)        | excl     | = mean(BLUE, OSCAR, H&C2023)                    |
| Gasser et al 2020    | excl     | OSCAR bookkeeping                               |
| FAO_EmisLUC          | incl     | FAOSTAT net LULUCF ("Land Use total"), a source |
| EDGAR_LU             | incl     | EDGAR LULUCF CO2, a source                      |
| PRIMAPhist           | incl     | PRIMAP-hist CAT5 (LUCF) CO2, a source           |

Axis 1 - PEAT. Bookkeeping estimates exclude peat drainage/fire; the
national-statistics series include it (drained organic soils). MAgPIE's
Land-use Change INCLUDES peat (separable via its `+|Peatland` child), so
the peat-clean bookkeeping comparison uses Land-use Change net of that
peat child (magpie4's `...|Land-use Change|Excl Peatland` line, where
present, provides this directly). The peat term (~1-1.5 Gt CO2/yr) is
small relative to the source magnitude and does not move the inventories
out of the LUC cloud.

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

GCB note - the GCB column ingested here is the bookkeeping-model MEAN
and is EX-peat: GCB == mean(BLUE, OSCAR, H&C2023) exactly (World 2020:
4298 == mean(5607, 4724, 2564)). The published GCB ELUC additionally
adds peat drainage/fire (a separate GCB.xlsx column) not folded into the
ingested net. GCB's peat column exists in the workbook but is
intentionally not ingested (it could not be an additive child of
Land-use Change, since GCB's net excludes it).

Do NOT benchmark net Land against GCB: the only Indirect / net
`Emissions|CO2|Land` series here is GCB's, where Indirect = the GCB
terrestrial sink S_LAND over ALL land (World 2020: -11403 Mt CO2/yr,
~the whole-biosphere sink), NOT the managed-land Grassi quantity MAgPIE
reports.

## Author

Michael Crawford

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidGlobalCarbonBudget")
} # }
```
