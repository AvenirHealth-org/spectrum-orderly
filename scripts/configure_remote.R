proj_root <- here::here()

location_name <- "sharepoint"

locations <- orderly::orderly_location_list()
if (!(location_name %in% locations)) {
  location_path <- Sys.getenv("ORDERLY_SHAREPOINT_LOCATION_PATH")
  if (location_path == "") {
    stop("Failed to configure orderly location, set ORDERLY_SHAREPOINT_LOCATION_PATH env var to configure")
  }
  message(sprintf("Registering new location '%s' at '%s'.", 
                  location_name, location_path))
  orderly::orderly_location_add_path(location_name, location_path)
} else {
  message(sprintf("Location '%s' already known.", location_name))
}
orderly::orderly_location_fetch_metadata(location_name)