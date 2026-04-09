# readHID

Read Historic Irrigation DataRead the Data from Siebert et.al on
Historic Irrigation for each Country. Data contains Area equiped for
Irrigation (AEI) from 1900 to 2005 in ten or five year timestepsThe Data
is also available spatialy explicit with a resolution of 5 arcmin:

## Usage

``` r
readHID(subtype = NULL)
```

## Arguments

- subtype:

  : Available subtypes are:

  - national_1900_2005 : National Data on AEI

  - AEI_EARTHSTAT_CP : Data in 5armin gridded resolution based on
    Earthstat LU scenario and maximum consistency with pasture extent

  - AEI_EARTHSTAT_IR : Data in 5armin gridded resolution based on
    Earthstat LU scenario and maximum consistency with AEI from
    subnationals regions

  - AEI_HYDE_LOWER_CP : Data in 5armin gridded resolution based on Hyde
    LU scenario from the lower end of the uncertainty band and maximum
    consistency with pasture extent

  - AEI_HYDE_LOWER_IR : Data in 5armin gridded resolution based on Hyde
    LU scenario from the lower end of the uncertainty band and maximum
    consistency with AEI from subnational regions

  - AEI_HYDE_FINAL_CP : Data in 5armin gridded resolution based on Hyde
    LU scenario final version and maximum consistency with pasture
    extent

  - AEI_HYDE_FINAL_IR : Data in 5armin gridded resolution based on Hyde
    LU scenario final version and maximum consistency with AEI from
    subnational regions

  - AEI_HYDE_UPPER_CP : Data in 5armin gridded resolution based on Hyde
    LU scenario from the upper end of the uncertainty band and maximum
    consistency with pasture extent

  - AEI_HYDE_UPPER_IR : Data in 5armin gridded resolution based on Hyde
    LU scenario from the upper end of the uncertainty band and maximum
    consistency with AEI from subnational regions

## Value

magpie object of the Irrigated Area data

## Details

Further information:

- S. Siebert, M. Kummu, M. Porkka, P. D??ll, N. Ramankutty, and B.R.
  Scanlon. 2015. A global data set of the extent of irrigated land from
  1900 to 2005. Hydrology and Earth System Sciences. Vol. 19. p.
  1521-1545.

- K. K. Goldwijk, A. Beusen, G. van Drecht, and M. de Vos. 2011. The
  HYDE 3.1 spatially explicit database of human-induced global land-use
  change over the past 12,000 years. Global Ecology and Biogeography.
  Vol. 20. p. 73-86

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Stephen Wirth

## Examples

``` r
if (FALSE) { # \dontrun{ 
a <- readSource("HID", "national_1900_2005")
} # }
```
