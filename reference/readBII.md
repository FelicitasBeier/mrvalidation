# readBII

Read and select scenarios and variables from the "The Biodiversity
Intactness Index - country, region and global-level summaries for the
year 1970 to 2050 under various scenarios" dataset. Default behavior is
to return BII for the historical period.

## Usage

``` r
readBII(subtype = "historical", subset = "bii")
```

## Arguments

- subtype:

  scenario selection, with potential values: "historical",
  "ssp1rcp2p6image", "ssp2rcp4p5messageglobiom", "ssp3rcp7p0aim",
  "ssp4rcp6p0gcam", "ssp5rcp8p5remindmagpie". Lists are accepted.

- subset:

  variable selection, with potential values: "bii", "crops",
  "highintensityag", "hpd", "pastureland", "qualitynatural",
  "urbanextent". Lists are accepted.

## Value

magclass object containing the desired subtypes and subsets

## See also

https://data.nhm.ac.uk/dataset/bii-bte

## Author

Michael Crawford

## Examples

``` r
if (FALSE) { # \dontrun{
  readSource("BII")
} # }
```
