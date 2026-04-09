# calcValidGridCroplandNitrogenWithdrawals

reports Cropland Nitrogen Withdrawals from soils on 0.5 degree grid

## Usage

``` r
calcValidGridCroplandNitrogenWithdrawals(irrigation = FALSE)
```

## Arguments

- irrigation:

  FALSE for the sum of irrigated and rainfed, FALSE for seperated
  categories, 'rainfed' or 'irrigated for single categories

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
calcOutput("ValidGridCroplandNitrogenWithdrawals")
} # }
```
