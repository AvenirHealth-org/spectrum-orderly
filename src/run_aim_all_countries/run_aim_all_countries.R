## Orderly script which locates a PJNZ from shared resources and runs
## extract via the CLI
## Note spectrum.exe will need to be available on your path for this to work

utils_path <- "spectrum_utils.R"
ex_config_template_path <- "aim_extract_template.ex"
ex_config_path <- "aim_extract.ex"
out_path <- "out.xlsx"

orderly::orderly_strict_mode()
params <- orderly::orderly_parameters(spectrum_version = NULL,
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

git_hash <- git_hash_from_spectrum_version(params$spectrum_version)
orderly::orderly_description(custom = list(spectrum_git_hash = git_hash))

country_csv_path <- "countries.csv"
orderly::orderly_shared_resource(country_csv_path)
countries <- read.csv(country_csv_path)

pjnz_files <- paste0(countries$iso3, ".PJNZ")
orderly::orderly_dependency("download_pjnz_all_countries", "latest",
                            pjnz_files)

orderly::orderly_shared_resource("env")
dotenv::load_dot_env("env")

set_extract_options(ex_config_template_path, ex_config_path,
                    params$recalculate_projection,
                    params$run_leapfrog)
## 3 hour time out
spectrum_extract(".", ex_config_path, out_path, timeout = 60 * 60 * 3)
