# readGMIA

Read Global Irrigation Map

Read the Data from Siebert et.al on Irrigated Areas for each Country.
Data contains total valuesas well as values from groundwater, surface
water and non convential water sources for the following Categories:

- Area equipped for Irrigation (AEI)

- Area acutally irrigated (AAI)

- Consumption Irrigatoin Water use (ICU)

The following Data is also available spatialy explicit with a resolution
of 5 arcmin:

- AEI in Percent

- AEI in Ha

- AAI as percent of AEI

- AEI from groundwater sources as percent of total AEI

- AEI from surface water sources as percent of total AEI

- AEI from non conventional sources as percent of total AEI

There also exists a correct function to aggregate the data to 0.5 degree
resolution, set convert="correctonly" to run.

## Usage

``` r
readGMIA(subtype = NULL)
```

## Arguments

- subtype:

  : Available subtypes are:

  - all_data_national : National Data on AEI (including differentiation
    by source (Groundwater, Surface water and nonconventional)), AAI

  - aei_pct : AEI in Percent

  - aei_ha : AEI in ha

  - aai_pct_aei : AAI as percentage of AEI

  - aeigw_pct_aei AEI from Groundwater sources as Percentage of total
    AEI

  - aeisw_pct_aei : AEI from Surface water sources as Percentage of
    total AEI

  - aeinc_pct_aei : AEI from nonconventional sources as Percentage total
    AEI

## Value

magpie object of the Irrigated Area data

## See also

[`readSource`](https://rdrr.io/pkg/madrat/man/readSource.html)

## Author

Stephen Wirth

## Examples

``` r
if (FALSE) { # \dontrun{
a <- readSource("GlobalIrrigationMap", "all_data_national")
a <- readSource ("GMIA", "aei_pct", convert = FALSE)
a <- readSource ("GMIA", "aei_pct", convert = "correctonly")
} # }
```
