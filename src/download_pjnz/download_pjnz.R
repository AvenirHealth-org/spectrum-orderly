orderly2::orderly_strict_mode()
params <- orderly2::orderly_parameters(iso3 = NULL)

out_path <- paste0(params$iso3, ".PJNZ")
orderly2::orderly_artefact(description = "Downloaded PJNZ file from dropbox", 
                           out_path)


## Note these are in Rob A's clone of the publicly accessible folder
## https://www.dropbox.com/scl/fo/sq9rveiuwbjpbp12rc886/AGdoAajJUPvV8fqgsCIiHGs/2024%20Estimates/Public%20files?rlkey=ojrctg7rm1czrdn2tv4um6jyl&subfolder_nav_tracking=1&st=sdq4ep08&dl=0
## but seemlingly you can't use the API to access a public file which seems
## a bit strange. Anyway this will do for now
dropbox_root <- "/Public files"
iso3_to_dropbox_path <- list(
  "AGO" = file.path(dropbox_root, "ESA/Angola_29May2024.pjnz"),
  "BRN" = file.path(dropbox_root, "AP/"),
  "KAZ" = file.path(dropbox_root, "EECA/Kaz MoreKnownPosANC +UA_11April2024.PJNZ"),
  "MWI" = file.path(dropbox_root, "ESA/Malawi_2024_v11_ART_Num.pjnz"),
  "PAK" = file.path(dropbox_root, "AP/Pakistan AEM-270524 WPP22 revised UA.PJNZ"),
  "ZAF" = file.path(dropbox_root, "ESA/South Africa 2024_Thembisa 4.7_ver03_ua.PJNZ")
)

if (!(iso3 %in% names(iso3_to_dropbox_path))) {
  stop(paste("No dropbox path configured for ISO3 code:", iso3))
}

dropbox_path <- iso3_to_dropbox_path[[iso3]]

message(paste("Downloading", dropbox_path, "to", out_path))
options("httr_oauth_cache" = FALSE)
rdrop2::drop_download(dropbox_path, out_path, overwrite = FALSE)

message("Download complete")