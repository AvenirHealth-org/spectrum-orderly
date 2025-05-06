spectrum_extract <- function(dir, config, output) {
  spectrum("/ExtractBatch", 
           normalizePath(dir), 
           normalizePath(config), 
           normalizePath(output))
}

spectrum <- function(...) {
  ## Note for this to work you must add Spectrum installation
  ## dir into your path
  spec <- sys_which("spectrum")
  res <- suppressWarnings(system2(spec, c(...), stdout = TRUE, stderr = TRUE,
                                  timeout = 180))
  if (system_success(res)) {
    return(res)
  }
  NULL
}

system_success <- function(x) is.null(attr(x, "status", exact = TRUE))

sys_which <- function(name) {
  path <- Sys.which(name)
  if (!nzchar(path)) {
    stop(sprintf("Did not find '%s'", name), call. = FALSE)
  }
  unname(path)
}

set_extract_options <- function(source_file, dest_file, 
                                recalculate_projection) {
  ex <- read.csv(source_file, header = FALSE)
  options_to_config <- list(
    recalculate_projection = "Recalculate projection: "
  )
  
  opts <- list(
    recalculate_projection = as.integer(recalculate_projection)
  )
  for (opt in names(opts)) {
    row <- ex[, 1] == options_to_config[[opt]]
    if (!any(row)) {
      stop(sprintf(
        "Failed to find option '%s' in extract file using row name '%s'.",
        opt, options_to_config[[opt]]))
    }
    ## Hardcoded in col2, first column is name, second col is the value for any
    ## boolean like option
    ex[row, 2] <- opts[[opt]]
  }
  ## Can just save in place because we're using orderly so this won't change
  ## the original
  write.table(ex, dest_file, 
              row.names = FALSE, quote = FALSE, sep = ",", 
              na = "", col.names = FALSE)
}