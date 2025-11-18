## Orderly script which locates a PJNZ from shared resources and runs
## extract via the CLI
## Note spectrum.exe will need to be available on your path for this to work

utils_path <- "spectrum_utils.R"
ex_config_template_path <- "aim_extract_template.ex"
ex_config_path <- "aim_extract.ex"
out_path <- "out.xlsx"

orderly::orderly_strict_mode()
params <- orderly::orderly_parameters(iso3 = NULL,
                                      spectrum_version = NULL,
                                      recalculate_projection = TRUE,
                                      run_leapfrog = FALSE)
orderly::orderly_shared_resource(ex_config_template_path)
orderly::orderly_artefact(
  description = "Extract configuration used after setting options via parameters", 
  ex_config_path)
orderly::orderly_artefact(description = "Extracted DP and AIM modvars", 
                          out_path)

orderly::orderly_shared_resource(utils_path)
source(utils_path)

orderly::orderly_shared_resource("env")
dotenv::load_dot_env("env")

git_hash <- git_hash_from_spectrum_version(params$spectrum_version)
orderly::orderly_description(custom = list(spectrum_git_hash = git_hash))

pjnz_path <- paste0(params$iso3, ".PJNZ")
orderly::orderly_dependency("download_pjnz",
                            "latest(parameter:iso3 == this:iso3)",
                            pjnz_path)

set_extract_options(ex_config_template_path, ex_config_path, 
                    params$recalculate_projection,
                    params$run_leapfrog)
spectrum_extract(".", ex_config_path, out_path)
