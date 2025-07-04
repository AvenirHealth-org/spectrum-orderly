# spectrum-orderly

An [Orderly2](https://github.com/mrc-ide/orderly2) project which will fit spectrum model via the extract CLI tool

## Prerequisite

1. [Install Spectrum](https://www.avenirhealth.org/software-spectrum.php)
2. Add spectrum.exe to your path
3. [Install orderly2](https://github.com/mrc-ide/orderly2?tab=readme-ov-file#installation)
4. Sync the [sharepoint remote](https://futuresinstitute.sharepoint.com/:f:/s/Programming/Es57cTFvF_tKv0KzTKacj_sBaCtvQKke_UtfB8_dzE-LzQ?e=65bdZw) to your
   local drive somewhere and add an env variable `ORDERLY_SHAREPOINT_LOCATION_PATH` with the fully qualified path.
5. If you want to run either of the "download_pjnz" tasks you'll need the [UNAIDS data dropbox](https://www.dropbox.com/scl/fo/o3gp67kjqj60gl64intii/AEwtIKpPM5Bu3HogQ9UJvR4?rlkey=8u3r3buretsmic8352wnul2iw&st=la9sy6rv&dl=0)
   synced to your local drive
6. If you want to run either of the "run_aim" tasks you'll need to generate a GitHub auth token which gives read content access to the [AvenirHealth-org/Spec5](https://github.com/AvenirHealth-org/Spec5) repo
   we use this to get the git hash from a spectrum release version number.
7. After 5 & 6 either run the helper script `./scripts/initialize_data.R` to set these vars up so orderly can read them. Or manually create a file at `shared/env` and enter the following
   ```
   PJNZ_ROOT_DIR=<Path to 2024 estimates folder from dropbox>
   GITHUB_AUTH_TOKEN=<generated github token>
   ```

## Running an orderly task

There are two tasks configured at the moment, 1 to download a PJNZ from dropbox and 1 to fit AIM using the PJNZ as a dependency.
At the moment the download PJNZ task is quite specific to Rob's dropbox structure (due to some limitations with programmatically downloading
public files from dropbox). So the best way to proceed, is for Rob to run those and push them to the remote from his machine. Then as long
as you have the sharepoint remote configured (see the section on "remote location") you'll be able to use these to run the fit report.

Run the report passing the relevant iso3 as a parameter

```
orderly2::orderly_run("run_aim", parameters = list(iso3 = "MWI"))
```

## Remote location

There is an orderly remote location configured on futures institute sharepoint at [this location](https://futuresinstitute.sharepoint.com/:f:/s/Programming/Es57cTFvF_tKv0KzTKacj_sBaCtvQKke_UtfB8_dzE-LzQ?e=SQVtNK)

To use the remote you must set it up

1. Sync the drive to your local machine and save the path you synced it to with as an env var `ORDERLY_SHAREPOINT_LOCATION_PATH`
2. Run the script `./scripts/configure_remote.R` to set up the remote location with the name "sharepoint"

You can now push, pull and query from the remote. See [docs](https://mrc-ide.github.io/orderly2/articles/collaboration.html) for details of working with the remote.

## Running via CI

AIM will run via orderly for all countries automatically every week via private repo [spectrum-orderly-runner](https://github.com/avenirhealth-org/spectrum-orderly-runner). You can also manually trigger the run.

To manually run go to the [spectrum-orderly-runner run AIM GitHub actions](https://github.com/AvenirHealth-org/spectrum-orderly-runner/actions/workflows/run-aim.yaml)

1. Click the "Run workflow" at the top right below the list of workflow runs
1. Always use the "main" branch here, but you can select the version of spectrum desktop to install. This must match one of the [release tags from Spec5 repo](https://github.com/AvenirHealth-org/Spec5/releases) e.g. v6.42 or v6.43-beta.3. If not specified it will use the release tagged as "latest"
1. The CI will install the specified version of Spectrum and then run Extract via the CLI and save the results. The orderly task will also record the hash of the Spec5 repo for this Spectrum version in metadata. It records the Spectrum version in parameters. These can be used for querying downstream.

## Integration into Spectrum regression testing tool

The [Spectrum regression testing tool](https://github.com/AvenirHealth-org/spectrum.regression.testing) is a Shiny app which can display data from orderly or from manually run Extracts. See the README in that repo for details.

## Updating the extract configuration

The extract configuration is stored in the [orderly repo shared directory](https://github.com/AvenirHealth-org/spectrum-orderly/blob/main/shared/aim_extract_template.ex) update this here
the configuration is used in this ShinyApp to know what indicators are available for display. The configuration from the orderly run will be read and used automatically.

This configuration was created by
1. Run "Extract"
2. Add any AIM projetion
3. Select all indicators
4. Save the configuration
5. Open the configuration in a text editor, remove the hard coded file path so the chosen projection section should look something like
   ```
   Number of chosen projections: ,1,,,,,,,,,,,,
   Chosen projections,,,,,,,,,,,,,
   ,,,,,,,,,,,,,
   ```
