# spectrum-orderly

An [Orderly2](https://github.com/mrc-ide/orderly2) project which will fit spectrum model via the extract CLI tool

## Pre-requisite

1. [Install Spectrum](https://www.avenirhealth.org/software-spectrum.php)
2. Add spectrum.exe to your path
3. [Install orderly2](https://github.com/mrc-ide/orderly2?tab=readme-ov-file#installation)

## Running an orderly task

1. You need to get a PJNZ file you want to extract from and put into the `shared/pjnz` directory with the name `<iso3>.pjnz` e.g. `MWI.pjnz`. All PJNZ files are gitignored to avoid pushing large or sensitive data.
2. Run the report passing the relevant iso3 as a parameter
   ```
   orderly2::orderly_run("fit_aim", parameters = list(iso3 = "MWI"))
   ```
