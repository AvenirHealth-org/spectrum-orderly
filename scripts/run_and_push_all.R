#!/usr/bin/env Rscript

'Run orderly fit AIM task and push to remote.

Usage:
  run_and_push_all.R
' -> doc

proj_root <- here::here()
args <- docopt::docopt(doc)

# Initialize if we are on a new CI runner, safe to re-run this.
orderly2::orderly_init(".")

source(file.path(proj_root, "scripts/consts.R"))
source(file.path(proj_root, "scripts/configure_remote.R"))

for (country in countries) {
  message(sprintf("Running fit AIM task for '%s'", country))
  id <- orderly2::orderly_run("fit_aim", 
                              parameters = list(iso3 = country),
                              echo = FALSE)
  orderly2::orderly_location_push(id, location_name)
}