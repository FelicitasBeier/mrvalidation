#' @title downloadGCBcountry
#' @description Download the Obermeier et al. (2024) country-level LULUCF carbon flux dataset
#' (net and gross fluxes of the GCB bookkeeping models), archived on Zenodo (8144174).
#' @author Florian Humpenoeder
#' @seealso \code{\link[madrat]{downloadSource}}
#' @examples
#' \dontrun{
#' downloadSource("GCBcountry")
#' }

downloadGCBcountry <- function() {

  baseUrl <- "https://zenodo.org/records/8144174/files/"
  files <- c("Obermeier_2023_Country_level_Net_fluxes.xlsx",
             "Obermeier_2023_Country_level_Gross_fluxes.xlsx")

  for (f in files) {
    download.file(paste0(baseUrl, f, "?download=1"), destfile = f, mode = "wb")
  }

  return(list(
    url          = "https://doi.org/10.5281/zenodo.8144174",
    doi          = "10.5194/essd-16-605-2024",
    title        = "Country-level estimates of gross and net carbon fluxes from LULUCF",
    unit         = "Mt C per year",
    author       = list(
      person("Wolfgang Alexander", "Obermeier"), person("Clemens", "Schwingshackl"),
      person("Ana", "Bastos"), person("Giulia", "Conchedda"), person("Thomas", "Gasser"),
      person("Giacomo", "Grassi"), person("Richard A.", "Houghton"),
      person("Francesco Nicola", "Tubiello"), person("Stephen", "Sitch"), person("Julia", "Pongratz")
    ),
    release_date = "2024-01-24",
    description  = paste("Country-level net and gross (source/sink) land-use-change carbon fluxes",
                         "from the three GCB bookkeeping models (BLUE, OSCAR, Houghton & Nassikas),",
                         "1950-2021, ex-peatland. GCB2022 vintage."),
    license      = "Creative Commons Attribution 4.0 License",
    reference    = paste("Obermeier, W. A., Schwingshackl, C., Bastos, A., Conchedda, G., Gasser, T.,",
                         "Grassi, G., Houghton, R. A., Tubiello, F. N., Sitch, S., and Pongratz, J.:",
                         "Country-level estimates of gross and net carbon fluxes from land use,",
                         "land-use change and forestry, Earth Syst. Sci. Data, 16, 605-645,",
                         "doi:10.5194/essd-16-605-2024, 2024.")
  ))
}
