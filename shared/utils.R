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
