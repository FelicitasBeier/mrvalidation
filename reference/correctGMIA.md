# correctGMIA

Correct Irrigated Area

Correct Irrigated Area to 0.5 Degree x 0.5 Degree Grid. Change
resolution from 5 arcmin to 0.5 Degree by aggregating. Values in ha are
summed up, Values in percent are calculated using mean.

## Usage

``` r
correctGMIA(x, subtype)
```

## Arguments

- x:

  MAgPIE object containing Global Map on Irrigaiton data data at 0.5
  Degree resolution

- subtype:

  : subtypes are the same as in readGMIA

## Value

Global Map on Irrigation data as MAgPIE object at a 0.5 Degree
resolution.

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Stephen Wirth

## Examples

``` r
if (FALSE) { # \dontrun{
a <- readSource("IrrigatedArea")
} # }
```
