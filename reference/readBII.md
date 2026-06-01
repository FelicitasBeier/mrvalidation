# readBII

Read the Biodiversity Intactness Index from the Natural History Museum.
Two dataset subtypes: \* "Phillips" (default) – Phillips et al. 2021
BII-BTE, historical scenario, country-level, returned as ISO x year x
scenario.variable. \* "DePalma" – De Palma et al. 2024 NHM v2.1.1 –
cellular x.y.iso on the 67420-cell lpjcell grid, fraction (0-1). Country
aggregation is left to the consumer (calcValidBII).

## Usage

``` r
readBII(subtype = "Phillips", subset = "bii")
```

## Arguments

- subtype:

  Dataset: "Phillips" (default, Phillips et al. 2021 historical BII) or
  "DePalma" (De Palma et al. 2024 v2.1.1 rasters).

- subset:

  Phillips variable selection ("bii", "crops", "highintensityag", "hpd",
  "pastureland", "qualitynatural", "urbanextent"; lists accepted).
  Ignored for subtype = "DePalma".

## Value

magclass object. Phillips: ISO x year x scenario.variable. DePalma:
x.y.iso x year x "bii" (fraction 0-1).

## Details

The De Palma rasters are 5 arc-minute WGS84 GeoTIFFs. terra::aggregate
(fact = 6, fun = "mean") brings them to 30 arc-minute (unweighted mean
is fine within a 6x6 block); terra::project pins to the canonical
0.5-deg grid; terra::extract samples the 67420 lpjcell coordinates.
Source is percent (0-100), divided by 100 for unit-parity with Phillips.
The data sub-dim is named "variable" so calcValidBII can use getNames(x,
dim = "variable") \<- ... on both subtypes.

## See also

https://data.nhm.ac.uk/dataset/bii-bte,
https://data.nhm.ac.uk/dataset/bii-developed-by-nhm-v2-1-1-limited-release,
[`downloadBII`](downloadBII.md), [`calcValidBII`](calcValidBII.md)

## Author

Michael Crawford, Florian Humpenoeder

## Examples

``` r
if (FALSE) { # \dontrun{
  readSource("BII")                      # Phillips historical
  readSource("BII", subtype = "DePalma") # De Palma 2024 v2.1.1
} # }
```
