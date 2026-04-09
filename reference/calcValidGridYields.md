# calcValidGridYields

reports Yields on 0.5 degree grid

## Usage

``` r
calcValidGridYields(
  datasource = "downscaledFAO",
  future = NULL,
  physical = TRUE
)
```

## Arguments

- datasource:

  downscaledFAO or calibratedFAO

- future:

  if NULL no future values are returned (default). specify climate
  scenario (gcm:rcp), if future is needed

- physical:

  if true (default) physical area (croparea) used for yield calculation;
  if false harvested area used for yield calculation

## Value

List of magpie objects with results on cellular level, weight on
cellular level, unit and description.

## See also

[`fullMADRATTOLPJML`](fullMADRATTOLPJML.md)

## Author

Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidGridYields")
} # }
```
