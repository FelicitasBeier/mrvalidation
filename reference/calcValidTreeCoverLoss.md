# calcValidTreeCoverLoss

Observed annual tree cover loss by dominant driver, for model
validation.

## Usage

``` r
calcValidTreeCoverLoss(datasource = "GFW")
```

## Arguments

- datasource:

  Currently only `"GFW"` (WRI/Google DeepMind drivers of tree cover
  loss, Sims et al. 2025, crossed with UMD/Hansen annual loss via the
  GFW data-api).

## Value

list of magpie object with data and weight

## Details

This is UMD/Hansen tree cover loss, not FAO forest loss, with each 1 km
cell assigned one dominant driver. All eight classes are returned,
although only shifting cultivation reaches module 35
(`f35_forest_lost_share`): an order-of-magnitude and pattern check, not
a target.

## Author

Michael Crawford

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidTreeCoverLoss", datasource = "GFW")
} # }
```
