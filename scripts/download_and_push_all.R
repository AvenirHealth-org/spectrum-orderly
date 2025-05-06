#!/usr/bin/env Rscript

'Run orderly Download PJNZ task and push to remote. Note this will only work interactively.

Usage:
  download_and_push_all.R [--force]
  
Options:
--force  If set then always re-run download, otherwise it will only run download task for new countries
' -> doc

proj_root <- here::here()
args <- docopt::docopt(doc)

source(file.path(proj_root, "scripts/consts.R"))
source(file.path(proj_root, "scripts/configure_remote.R"))

for (country in countries) {
  existing_id <- orderly2::orderly_search("latest(parameter:iso3 == this:iso3)",
                                          name = "download_pjnz",
                                          parameters = list(iso3 = country),
                                          location = location_name)

  if (args$force || is.na(existing_id)) {
    message(sprintf("Running download task for '%s'", country))
    id <- orderly2::orderly_run("download_pjnz", 
                                parameters = list(iso3 = country),
                                echo = FALSE)
    orderly2::orderly_location_push(id, location_name)
  } else {
    message(sprintf("Skipping run for '%s', as it already exists on the remote",
                    country))
  }
}