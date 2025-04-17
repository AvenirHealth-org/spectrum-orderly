#!/usr/bin/env Rscript

'Download PJNZ file from Dropbox

Usage:
  download_pjnz.R --iso3=<iso3> [--token=<token>]

Options:
  --iso3=<iso3>   The ISO3 country code
  --token=<token> The auth token for dropbox with access to files, alternatively uses env var DROPBOX_TOKEN
' -> doc

proj_root <- here::here()
args <- docopt::docopt(doc)
iso3 <- toupper(args$iso3)

## Getting a dropbox token is a little awkward and confusing, easiest
## way I have found is to create an app via the app console
## https://www.dropbox.com/developers/apps?_tk=pilot_lp&_ad=topbar4&_camp=myapps
## then go to the API documentation site
## https://www.dropbox.com/developers/documentation/http/documentation#files-download
## and under the example click "generate" and this will create one you can use
token <- args$token
if (is.null(token)) {
  token <- Sys.getenv("DROPBOX_TOKEN")
}
if (token == "") {
  stop("No dropbox token supplied, pass as argument or via DROPBOX_TOKEN env var")
}

dropbox_api_download_url <- "https://content.dropboxapi.com/2/files/download"
dropbox_download <- function(source_path, local_path, overwrite) {
  write <- httr::write_disk(local_path, overwrite)
  
  headers <- httr::add_headers(
    Authorization = paste("Bearer", token),
    "Dropbox-API-Arg" = sprintf('{"path": "%s"}', source_path))
  r <- httr::POST(
    dropbox_api_download_url,
    headers,
    write)
  httr::stop_for_status(r)
  local_path
}

## Note these are in Rob A's clone of the publicly accessible folder
## https://www.dropbox.com/scl/fo/sq9rveiuwbjpbp12rc886/AGdoAajJUPvV8fqgsCIiHGs/2024%20Estimates/Public%20files?rlkey=ojrctg7rm1czrdn2tv4um6jyl&subfolder_nav_tracking=1&st=sdq4ep08&dl=0
## but seemlingly you can't use the API to access a public file which seems
## a bit strange. Anyway this will do for now
dropbox_root <- "/Public files"
iso3_to_dropbox_path <- list(
  "AGO" = file.path(dropbox_root, "ESA/Angola_29May2024.pjnz"),
  "MWI" = file.path(dropbox_root, "ESA/Malawi_2024_v11_ART_Num.pjnz")
)

if (!(iso3 %in% names(iso3_to_dropbox_path))) {
  stop(paste("No dropbox path configured for ISO3 code:", iso3))
}

dropbox_path <- iso3_to_dropbox_path[[iso3]]
local_path <- file.path(proj_root, "shared", "pjnz", paste0(iso3, ".pjnz"))

dir.create(dirname(local_path), showWarnings = FALSE, recursive = TRUE)

message(paste("Downloading", dropbox_path, "to", local_path))
dropbox_download(dropbox_path, local_path = local_path, overwrite = TRUE)

message("Download complete")