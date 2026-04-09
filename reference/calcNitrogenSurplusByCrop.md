# calcNitrogenSurplusByCrop

calculates the crop-specific nitrogen losses and the balanceflow for
countries with unrealistically high nitrogen uptake efficiencies

## Usage

``` r
calcNitrogenSurplusByCrop(
  indicator = "total",
  deposition = "Nsurplus2",
  cellular = FALSE
)
```

## Arguments

- indicator:

  total: estimates the inputs per total crop production; by_area
  estimates the inputs per area harvested

- deposition:

  if FALSE, deposition is not accounted for in the distribution. Use
  FALSE to avoid circularities in calcNitrogenBudget

- cellular:

  cellular disaggreagation or national values

## Value

List of magpie objects with results on country level, weight on country
level, unit and description.

## See also

[`calcNitrogenBudgetCropland`](https://rdrr.io/pkg/mrcommons/man/calcNitrogenBudgetCropland.html)

## Author

Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{ 
calcOutput("NitrogenSurplusByCrop")
} # }
```
