#' @title downloadBII
#' @description Download a Biodiversity Intactness Index dataset from the
#' Natural History Museum. Two subtypes:
#'   * "Phillips" (default) -- Phillips et al. 2021 BII-BTE
#'     (\doi{10.5519/he1eqmg1}); country/region tables, 1970-2050 incl. SSPs.
#'   * "DePalma" -- De Palma et al. 2024 NHM v2.1.1 (\doi{10.5519/k33reyb6});
#'     global 5 arc-minute GeoTIFFs for 2000, 2005, 2010, 2015, 2020.
#' @param subtype "Phillips" (default) or "DePalma".
#' @seealso https://data.nhm.ac.uk/dataset/bii-bte, \code{\link{readBII}}
#' @author Michael Crawford, Florian Humpenoeder
#'
#' @return Metadata on the downloaded BII data.
#'
#' @details
#' Both NHM resource URLs are behind Cloudflare and return HTTP 403 to
#' non-browser clients, so both downloads use the portal's content-addressable
#' \code{/downloads/direct/<sha>.zip} endpoint, which bypasses the challenge.
#' Phillips uses the CSV resource (the .rds resource has no working direct URL);
#' De Palma uses the v2.1.1 raster ZIP. If a URL becomes unreachable, download
#' via a browser and place the file in this source folder.
#'
#' @examples
#'
#' \dontrun{
#'   downloadSource("BII")
#'   downloadSource("BII", subtype = "DePalma")
#' }
#'
#' @importFrom utils download.file person unzip

downloadBII <- function(subtype = "Phillips") {

  # nolint start

  if (identical(subtype, "DePalma")) {
    url     <- "https://data.nhm.ac.uk/downloads/direct/8161226fda7a36ca0b94f2becee9afe1b318d0a8.zip"
    zipFile <- "bii-v2-1-1-nhm-data-portal.zip"
    if (!file.exists(zipFile)) {
      tryCatch(
        utils::download.file(url, destfile = zipFile, mode = "wb"),
        error = function(e) {
          stop("Automated NHM download failed (Cloudflare likely). Manually download from ",
               "https://data.nhm.ac.uk/dataset/bii-developed-by-nhm-v2-1-1-limited-release ",
               "and place '", zipFile, "' in this source folder. Original error: ", conditionMessage(e))
        }
      )
    }
    # Cloudflare challenge stub is ~6 KB; real ZIP is ~45 MB.
    if (file.size(zipFile) < 1e7) {
      stop("'", zipFile, "' is too small (", file.size(zipFile),
           " bytes) -- likely a Cloudflare challenge page. Manually download via browser.")
    }
    # Outer ZIP holds an inner ZIP (resource-ID-named) + manifest; inner ZIP has the 5 GeoTIFFs.
    utils::unzip(zipFile, exdir = ".")
    innerZip <- "c4c281c4-befa-4e1b-a162-ba2f25e5ae82.zip"
    if (!file.exists(innerZip)) {
      stop("Inner archive '", innerZip, "' missing -- NHM ZIP layout may have changed.")
    }
    utils::unzip(innerZip, exdir = ".")
    return(list(url          = "https://data.nhm.ac.uk/dataset/bii-developed-by-nhm-v2-1-1-limited-release",
                doi          = "https://doi.org/10.5519/k33reyb6",
                title        = "The Biodiversity Intactness Index developed by The Natural History Museum, London, v2.1.1 (Open Access, Limited Release)",
                unit         = "Percentage (0-100)",
                author       = list(person("Adriana", "De Palma"), person("Sara", "Contu"),
                                    person("Gareth E", "Thomas"), person("Connor", "Duffin"),
                                    person("Sabine", "Nix"), person("Andy", "Purvis")),
                version      = "v2.1.1",
                release_date = "2024-10-09",
                description  = "Global gridded BII at 5 arc-minute resolution for 2000, 2005, 2010, 2015, 2020. Values 0-100 (100 = fully intact).",
                license      = "CC-BY-NC-SA 4.0",
                reference    = "Adriana De Palma; Sara Contu; Gareth E Thomas; Connor Duffin; Sabine Nix; Andy Purvis (2024). The Biodiversity Intactness Index developed by The Natural History Museum, London, v2.1.1 (Open Access, Limited Release) [Data set]. Natural History Museum. https://doi.org/10.5519/k33reyb6")
    )
  }

  # Phillips et al. 2021 (default). CKAN resource URL is Cloudflare-blocked;
  # use the /downloads/direct/<sha>.zip endpoint (CSV resource -- the .rds has
  # no working direct URL). The ZIP holds resource.csv + manifest.json.
  url     <- "https://data.nhm.ac.uk/downloads/direct/bcaa1a8726032605ed11b1db0cb503d6e00ad584.zip"
  zipFile <- "bii-bte-nhm-data-portal.zip"
  if (!file.exists(zipFile)) {
    tryCatch(
      utils::download.file(url, destfile = zipFile, mode = "wb"),
      error = function(e) {
        stop("Automated NHM download failed (Cloudflare likely). Manually download from ",
             "https://data.nhm.ac.uk/dataset/bii-bte and place '", zipFile,
             "' in this source folder. Original error: ", conditionMessage(e))
      }
    )
  }
  if (file.size(zipFile) < 1e6) {
    stop("'", zipFile, "' is too small (", file.size(zipFile),
         " bytes) -- likely a Cloudflare challenge page. Manually download via browser.")
  }
  utils::unzip(zipFile, exdir = ".")
  if (file.exists("resource.csv")) file.rename("resource.csv", "BII_historical_and_SSPs.csv")

  return(list(url           = "https://data.nhm.ac.uk/dataset/bii-bte",
              doi           = "https://doi.org/10.5519/he1eqmg1",
              title         = "The Biodiversity Intactness Index - country, region and global-level summaries for the year
                                  1970 to 2050 under various scenarios",
              unit          = "Unitless",
              author        = list(person("Helen", "Phillips"),
                                   person("Adriana", "De Palma"),
                                   person("Ricardo E", "Gonzalez"),
                                   person("Sara", "Contu"),
                                   person("Samantha L L", "Hill"),
                                   person("Andres", "Baselga"),
                                   person("Luca", "Borger"),
                                   person("Andy", "Purvis")),
              version       = NULL,
              release_date  = "October 4, 2021",
              description   = "Using the PREDICTS database of local biodiversity measures at thousands of sites around the world,
                                  we statistically modelled how total abundance of organisms and compositional similarity responded
                                  to land use and related pressures. We combined these models with spatio-temporal projections of
                                  explanatory variables (at 0.25 degrees spatial resolution) from the year 1970 to 2050 under five
                                  Shared Socioeconomic Pathways (SSPs) to project the Biodiversity Intactness Index (BII). Mean BII
                                  (weighted by cell area) was calculated at the country, subregion, interregion and global level. We
                                  used cross-validation (leaving one biome out in turn) to produce decadal upper and lower uncertainty
                                  margins for 1970-2050. These summary data were uploaded to the Natural History Museum's Biodiversity
                                  Trends Explorer on 2021-10-27. We have also provided mean values of some of the pressures, as changes
                                  in these contribute to changes in BII.",
              license       = "Creative Commons Non-Commercial",
              reference     = "Helen Phillips; Adriana De Palma; Ricardo E Gonzalez; Sara Contu et al. (2021). The Biodiversity
                                  Intactness Index - country, region and global-level summaries for the year 1970 to 2050 under
                                  various scenarios [Data set]. Natural History Museum. ")
  )

  # nolint end
}
