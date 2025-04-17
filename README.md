# spectrum-orderly

An [Orderly2](https://github.com/mrc-ide/orderly2) project which will fit spectrum model via the extract CLI tool

## Prerequisite

1. [Install Spectrum](https://www.avenirhealth.org/software-spectrum.php)
2. Add spectrum.exe to your path
3. [Install orderly2](https://github.com/mrc-ide/orderly2?tab=readme-ov-file#installation)

## Running an orderly task

1. You need to get a PJNZ file you want to extract from and put into the `shared/pjnz` directory with the
  name `<iso3>.pjnz` e.g. `MWI.pjnz`. All PJNZ files are gitignored to avoid pushing large or sensitive data.
   * You can clone these from dropbox if you want using the provided script `./scripts/download_pjnz.R --iso3=MWI --token=<auth-token>`. 
     Getting an auth token from dropbox is a little fiddly. The easiest way I found is to add an auth app 
     via the [app console](https://www.dropbox.com/developers/apps?_tk=pilot_lp&_ad=topbar4&_camp=myapps) and 
     ensure it has the "files.content.read" permission. Then go to the docs for the 
     [api download endpoint](https://www.dropbox.com/developers/documentation/http/documentation#files-download). Under
     the example you should be able to see some green text "get access token". Set the "Get access token for:" to the app
     you just created, then click "get access token" within the example. You can then set this as an env var `DROPBOX_TOKEN` or pass to the CLI.
2. Run the report passing the relevant iso3 as a parameter
   ```
   orderly2::orderly_run("fit_aim", parameters = list(iso3 = "MWI"))
   ```
