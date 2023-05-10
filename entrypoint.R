#!/usr/local/bin/Rscript

dht::greeting()

dht::check_ram(4)

doc <- "
      Usage:
      entrypoint.R <filename>
      "

opt <- docopt::docopt(doc)

## for interactive testing
## opt <- docopt::docopt(doc, args = "address.csv")

d_in <- readr::read_csv(opt$filename, show_col_types = FALSE)
cli::cli_alert_success("imported data from {opt$filename}")
if (!"address" %in% names(d_in)) cli::cli_alert_("no column called address found in the input file", call. = FALSE)

d <-
  d_in |>
  dplyr::select(input_address = address) |>
  dplyr::distinct()

d$cleaned_address <- dht::clean_address(d$input_address)

## expanding addresses
cli::cli_alert_warning("more than one address row will likely be returned for each input address row")

d$expanded_addresses <-
  system2("/code/libpostal/src/libpostal", "--json", input = d$cleaned_address, stdout = TRUE) |>
  purrr::map(jsonlite::fromJSON) |>
  purrr::map("expansions")

d <- d |> tidyr::unnest(cols = c(expanded_addresses))

d_out <- dplyr::left_join(d_in, d, by = c("address" = "input_address"))

dht::write_geomarker_file(d_out, filename = opt$filename, argument = opt$expand)
