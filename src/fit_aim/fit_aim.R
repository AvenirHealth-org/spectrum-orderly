## Orderly script which locates a PJNZ from shared resources and runs
## extract via the CLI
## Note spectrum.exe will need to be available on your path for this to work

utils_path <- "utils.R"
pjnz_dir <- "pjnz"
ex_config_template_path <- "aim_extract_template.ex"
ex_config_path <- "aim_extract.ex"
out_path <- "out.xlsx"

orderly2::orderly_strict_mode()
orderly2::orderly_parameters(iso3 = NULL)
orderly2::orderly_resource(ex_config_template_path)
orderly2::orderly_parameters(recalculate_projection = TRUE)
orderly2::orderly_parameters(spectrum_version = "6.43")
orderly2::orderly_artefact(
  description = "Extract configuration used after setting options via parameters", 
  ex_config_path)
orderly2::orderly_artefact(description = "Extracted DP and AIM modvars", 
                           out_path)

orderly2::orderly_shared_resource(utils_path)
source(utils_path)

orderly2::orderly_shared_resource(file.path(pjnz_dir, paste0(iso3, ".pjnz")))

set_extract_options(ex_config_template_path, ex_config_path, 
                    recalculate_projection)
spectrum_extract(pjnz_dir, ex_config_path, out_path)
