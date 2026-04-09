# calcValidCropareaDiversity

calculates validation for croparea diversity index. As opposed to
CropareaDiversityIndex from magpie4 due to lack of data fallow land is
not considered

## Usage

``` r
calcValidCropareaDiversity(index = "shannon", groupdiv = "agg1")
```

## Arguments

- index:

  can be "shannon", "gini" or "invsimpson" for different types of
  diversitiy indices

- groupdiv:

  should crop groups be split up into several individual items or not?
  Choose either FALSE or different (dis)aggregation methods "agg1",
  "agg2"

## Value

MAgPIE object (unit depends on attributes)

## Author

Patrick v. Jeetze, Benjamin Leon Bodirsky

## Examples

``` r
if (FALSE) { # \dontrun{
x <- calcOutput("ValidCropareaDiversity", index = "shannon", groupdiv = "agg1", aggregate = FALSE)
} # }
```
