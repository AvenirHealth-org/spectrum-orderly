#!/usr/bin/env Rscript

'Run orderly fit AIM task and push to remote.

Usage:
  run_and_push_all.R [--leapfrog]

Options:
--leapfrog  If set, then run the leapfrog model otherwise runs the default spectrum model
' -> doc

proj_root <- here::here()
args <- docopt::docopt(doc)

# Initialize if we are on a new CI runner, safe to re-run this.
orderly::orderly_init(".")

source(file.path(proj_root, "scripts/configure_remote.R"))
source(file.path(proj_root, "shared/spectrum_utils.R"))

version <- spectrum_version()

message("Running orderly task")
id <- orderly::orderly_run("run_aim_all_countries",
                            parameters = list(spectrum_version = version,
                                              run_leapfrog = args$leapfrog),
                            location = c("local", location_name),
                            echo = FALSE)
orderly::orderly_location_push(id, location_name)
