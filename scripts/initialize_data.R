#!/usr/bin/env Rscript

root <- here::here()

message("This orderly project requires external data from dropbox to run.")
message("The folder can be found here https://www.dropbox.com/scl/fo/o3gp67kjqj60gl64intii/AEwtIKpPM5Bu3HogQ9UJvR4?rlkey=8u3r3buretsmic8352wnul2iw&st=wk1dgxaz&dl=0")
message(paste("Copy or sync the 'Public files' and 'Non public spectrum files' from '2024 Estimates'",
              "folder onto your local machine and enter the path below."))
message("Path will be interpreted as a string, there is no need to escape spaces.")
cat("Local path to PJNZ dir: ")
path <- readLines("stdin", n = 1)

if (!file.exists(path)) {
  ## We've probably not synced correctly
  stop(sprintf("Failed to locate path '%s', is there a typo? Check path exists and try again", path))
}

if (!file.exists(file.path(path, "Public files")) || !file.exists(file.path(path, "Non public spectrum files"))) {
  ## We've probably not synced the correct folder
  stop(sprintf(paste("Failed to locate 'Public files' and 'Non public spectrum",  
                     "files' folders in dir at path '%s', have you synced the",  
                     "correct directory?"), 
               path)
       )
}

writeLines(paste0("PJNZ_ROOT_DIR=", path), file.path(root, "shared/.env"))