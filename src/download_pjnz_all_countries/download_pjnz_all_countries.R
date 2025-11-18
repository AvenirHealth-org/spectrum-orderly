## This is a bit of a weird orderly task. I want to run the "run_model" tasks
## on CI, they require access to the PJNZ files. So we've got a couple of
## options for accessing them on the CI runners.
## 1. Sync them with dropbox onto the self-hosted runner
## 2. Download them on demand via rdrop2
## 3. Access them from sharepoint
## 
## Turns out 2. doesn't work outside of an interactive context, rdrop2 doesn't
## have the most up to date auth model and I couldn't get this to work
## well without someone being present to authorise the rdrop2 app in dropbox.
## 1. Is similarly really hard to do without manual intervention
## So we're at 3, so we need a copy of the files on sharepoint. It felt
## easiest to do this by just writing this task to download and push them up
## to the remote. Perhaps it would have been easier to just copy the files
## in bulk. But here we are.

orderly::orderly_strict_mode()

## Note that to run this you will have to have a local copy of the UNAIDS 
## spectrum files from Dropbox. Either from downloading or dropbox sync
## Then run ./scripts/
country_csv_path <- "countries.csv"
orderly::orderly_shared_resource(country_csv_path)
countries <- read.csv(country_csv_path)
iso3_to_dropbox_path <- setNames(countries$path, countries$iso3)

orderly::orderly_shared_resource("env")
dotenv::load_dot_env("env")
PJNZ_ROOT_DIR <- Sys.getenv("PJNZ_ROOT_DIR")

for (iso3 in countries$iso3) {
  out_path <- paste0(iso3, ".PJNZ")
  orderly::orderly_artefact(
    description = sprintf("Copy %s PJNZ from local path into orderly", iso3),
    out_path)
  
  dropbox_path <- file.path(PJNZ_ROOT_DIR, iso3_to_dropbox_path[[iso3]])
  
  message(sprintf("Downloading %s", iso3))
  
  file.copy(dropbox_path, out_path)
  
  message(sprintf("Download complete for %s", iso3))
}