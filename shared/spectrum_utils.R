spectrum_extract <- function(dir, config, output, timeout = 180) {
  spectrum("/ExtractBatch", 
           normalizePath(dir), 
           normalizePath(config), 
           normalizePath(output),
           timeout = timeout)
}

spectrum_version <- function() {
  spectrum("/Version", timeout = 30)
}

spectrum <- function(..., timeout) {
  ## Note for this to work you must add Spectrum installation
  ## dir into your path
  spec <- sys_which("spectrum")
  res <- suppressWarnings(system2(spec, c(...), stdout = TRUE, stderr = TRUE,
                                  timeout = timeout))
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

git_hash_from_spectrum_version <- function(version) {
  ## list releases and get hash
  ## need auth token
  tag <- paste0("v", version)
  token <- Sys.getenv("GITHUB_AUTH_TOKEN")
  org <- "AvenirHealth-org"
  repo <- "Spec5"
  res <- httr::GET(
    sprintf("https://api.github.com/repos/%s/%s/git/ref/tags/%s", org, repo, tag),
    httr::add_headers(Accept = "application/vnd.github+json",
                      Authorization = paste("Bearer", token))
  )
  if (httr::status_code(res) != 200) {
    stop(sprintf("Failed to get git tag '%s', check version number is correct", tag))
  }
  body <- httr::content(res)
  if (body$object$type == "commit") {
    sha <- body$object$sha
  } else {
    res_sha <- httr::GET(
      sprintf("https://api.github.com/repos/%s/%s/git/tags/%s", org, repo, body$object$sha),
      httr::add_headers(Accept = "application/vnd.github+json",
                        Authorization = paste("Bearer", token))
    )
    if (httr::status_code(res) != 200) {
      stop(sprintf("Failed to get ref from git tag '%s', check version number is correct", tag))
    }
    body_sha <- httr::content(res_sha)
    sha <- body_sha$object$sha
  }
  substr(sha, 1, 7)
}