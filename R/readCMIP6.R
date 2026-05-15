#' @title readCMIP6
#' @description Read near-surface air temperature projection from CMIP6 for the following scenarios:
#' SSP1-1.9, SSP1-2.6, SSP2-4.5, SSP3-7.0, SSP4-3.4, SSP4-6.0, SSP5-8.5, SSP5-3.4-over
#' @seealso https://cmip6.science.unimelb.edu.au/
#' @author Michael Crawford
#'
#' @return a magclass object
#'
#' @examples
#'
#' \dontrun{
#'   readSource("CMIP6")
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom stringr str_split str_extract
#' @importFrom utils read.table
#' @importFrom dplyr %>% select rename mutate filter summarise pull bind_rows group_by n distinct sample_n semi_join arrange
#' @importFrom tidyr expand_grid nest unnest
#' @importFrom purrr map
#' @importFrom rlang .data
#' @importFrom magclass as.magpie magpiesort

readCMIP6 <- function() {

    # ---------------------------------------------------------------------------------------
    # Global variables
    basePeriod  <- seq(1951, 1980)
    magpieYears <- seq(1995, 2100)

    # ---------------------------------------------------------------------------------------
    # Functions
    .loadScenario <- function(filepath) {

        filename    <- file_path_sans_ext(basename(filepath))
        identifiers <- str_split(filename, pattern = "_")
        sourceID    <- identifiers[[1]][4]
        scenario    <- identifiers[[1]][5]
        variant     <- identifiers[[1]][6]

        # some scenarios don't have base periods and thus must be treated differently
        timespan      <- as.numeric(unlist(str_split(identifiers[[1]][8], pattern = "-")))
        hasBasePeriod <- all(basePeriod %in% seq(from = timespan[1], to = timespan[2]))

        firstRow <- str_extract(pattern = "(?<=THISFILE_FIRSTDATAROW = )(.*)",
                                string  = paste(readLines(filepath), collapse = "\n"))

        d <- read.table(file = filepath, skip = as.numeric(firstRow) - 2, header = TRUE)

        d <- d %>%
            select(.data$YEARS, .data$WORLD) %>%
            rename(Year  = .data$YEARS,
                   Value = .data$WORLD) %>%
            mutate(Region        = "GLO",
                   Model         = sourceID,
                   Variant       = variant,
                   Scenario      = scenario,
                   hasBasePeriod = hasBasePeriod) %>%
            select(.data$Region, .data$Year,
                   .data$Model, .data$Scenario,
                   .data$Variant, .data$hasBasePeriod,
                   .data$Value)

        d <- d %>% filter(.data$Year %in% c(basePeriod, magpieYears)) # remove extra years

        d <- d %>% mutate(Value = .data$Value - 273.15) # convert from K to C

        return(d)
    }

    .fillBasePeriods <- function(data) {

        noBasePeriod <- data %>%
            filter(.data$hasBasePeriod == FALSE) %>%
            distinct(.data$Scenario, .data$Variant)

        yesBasePeriod <- data %>%
            filter(.data$hasBasePeriod == TRUE) %>%
            distinct(.data$Scenario, .data$Variant)

        # if this model doesn't have any base periods we throw it out (e.g. CAS-ESM2-0, MPI-ESM1-2-HR, KIOST-ESM)
        if (nrow(yesBasePeriod) == 0) {
            return(NULL)
        }

        # some scenarios don't have base periods, so we append the base period from another run of the same model
        if (nrow(noBasePeriod) > 0) {

            sampleBasePeriodID <- sample_n(yesBasePeriod, 1)
            basePeriodData <- suppressMessages(semi_join(x = data, y = sampleBasePeriodID)) %>%
                filter(.data$Year %in% basePeriod) %>%
                select(-.data$Scenario, -.data$Variant)

            basePeriods <- expand_grid(noBasePeriod, basePeriodData)

            data <- bind_rows(data, basePeriods) %>%
                arrange(.data$Scenario, .data$Variant, .data$Region, .data$Year)

        }

        data <- data %>% select(-.data$hasBasePeriod)

        return(data)
    }

    .calculateChangeInTemperature <- function(data) {

        basePeriodAvgTemp <- data %>%
            filter(.data$Year %in% basePeriod) %>%
            summarise(mean(.data$Value)) %>%
            pull()

        data <- data %>%
            filter(.data$Year %in% magpieYears) %>%
            mutate(Value = .data$Value - basePeriodAvgTemp)

        return(data)

    }

    # ---------------------------------------------------------------------------------------
    # Body
    files <- list.files(".", pattern = "*.MAG", recursive = TRUE, full.names = TRUE)

    d <- map(.x = files, .f = .loadScenario) %>%
        bind_rows()

    d <- d %>%
        group_by(.data$Model) %>%
        nest() %>%
        mutate(data = map(.x = .data$data, .f = .fillBasePeriods)) %>%
        unnest(cols = c(.data$data))

    d <- d %>%
        group_by(.data$Model, .data$Scenario, .data$Variant) %>%
        nest() %>%
        mutate(data = map(.x = .data$data, .f = .calculateChangeInTemperature)) %>%
        unnest(cols = c(.data$data))

    # average each individual model, scenario, across its different variants. Some models have
    # incomplete coverage between variants (e.g. MRI-ESM2-0 has several variants ending in 2050
    # for the SSP245 scenario). In this current methodology, these variants are still
    # averaged together.
    d <- d %>%
        group_by(.data$Model, .data$Scenario, .data$Year) %>%
        summarise(Value = mean(.data$Value, na.rm = TRUE))

    mag <- as.magpie(d)
    mag <- magpiesort(mag)

    return(mag)
}
