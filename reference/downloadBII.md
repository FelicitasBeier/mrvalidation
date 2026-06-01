# downloadBII

Download a Biodiversity Intactness Index dataset from the Natural
History Museum. Two subtypes: \* "Phillips" (default) – Phillips et al.
2021 BII-BTE ([doi:10.5519/he1eqmg1](https://doi.org/10.5519/he1eqmg1)
); country/region tables, 1970-2050 incl. SSPs. \* "DePalma" – De Palma
et al. 2024 NHM v2.1.1
([doi:10.5519/k33reyb6](https://doi.org/10.5519/k33reyb6) ); global 5
arc-minute GeoTIFFs for 2000, 2005, 2010, 2015, 2020.

## Usage

``` r
downloadBII(subtype = "Phillips")
```

## Arguments

- subtype:

  "Phillips" (default) or "DePalma".

## Value

Metadata on the downloaded BII data.

## Details

Both NHM resource URLs are behind Cloudflare and return HTTP 403 to
non-browser clients, so both downloads use the portal's
content-addressable `/downloads/direct/<sha>.zip` endpoint, which
bypasses the challenge. Phillips uses the CSV resource (the .rds
resource has no working direct URL); De Palma uses the v2.1.1 raster
ZIP. If a URL becomes unreachable, download via a browser and place the
file in this source folder.

## See also

https://data.nhm.ac.uk/dataset/bii-bte, [`readBII`](readBII.md)

## Author

Michael Crawford, Florian Humpenoeder

## Examples

``` r
if (FALSE) { # \dontrun{
  downloadSource("BII")
  downloadSource("BII", subtype = "DePalma")
} # }
```
