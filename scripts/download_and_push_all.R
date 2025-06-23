#!/usr/bin/env Rscript

'Run orderly Download all PJNZ task and push to remote. Note this will only work interactively.

Usage:
  download_and_push_all.R
' -> doc

proj_root <- here::here()
args <- docopt::docopt(doc)

source(file.path(proj_root, "scripts/configure_remote.R"))

id <- orderly2::orderly_run("download_pjnz_all_countries",
                      echo = FALSE)
orderly2::orderly_location_push(id, location_name)