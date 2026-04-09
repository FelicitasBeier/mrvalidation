# calcValidGridNutrientAWMS

reports Nutrient load in animal waste management on 0.5 degree grid

## Usage

``` r
calcValidGridNutrientAWMS(nutrient = c("nr", "c"))
```

## Arguments

- nutrient:

  can be c, nr, p, k. For p and k, no losses are assumed in
  confinements.

## Value

List of magpie objects with results on cellular level, weight on
cellular level, unit and description.

## See also

[`fullMADRATTOLPJML`](fullMADRATTOLPJML.md)

## Author

Kristine Karstens, Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{
calcOutput("ValidGridNitrogenBudgetCropland")
} # }
```
