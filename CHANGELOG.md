## 0.4.1

- Key desaturation variables have been labeled with `hypoxia` and `hypoxemia` to allow for easy searching on sleepdata.org

## 0.4.0 (July 3, 2014)

- Removed data for subjects who did not consent to share their data
- The CSV datasets generated from a SAS export is located here:
  - `\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.4.0\`
    - `shhs1-dataset-0.4.0.csv`
    - `shhs2-dataset-0.4.0.csv`
    - `shhs-cvd-dataset-0.4.0.csv`
- **Gem Changes**
  - Updated to spout 0.8.0
- Issues with data from the BioLINCC datasets for v0.4.0 (i.e. extreme values) have been grouped into a [Known Issues](https://github.com/sleepepi/shhs-data-dictionary/blob/master/KNOWNISSUES.md) list
- Added the following forms to variables
  - Health Interview (ARIC, CHS, Tucscon/Strong Heart)
  - Health Interview (Framingham)
  - Health Interview (New York)
  - PSG Scoring Notes
  - Health Interview (SHHS2)
  - Morning Survey (SHHS2)
  - Physical Measurements, Blood Pressure, Ankle-Arm Index, ECG
  - Quality of Life Survey (SF-36)

## 0.3.0 (June 20, 2014)

- Removed `in_shhs2_lad` variable (i.e. participant was part of SHHS2 Limited Access Dataset) as it is no longer relevant
- **Gem Changes**
  - Use of Ruby 2.1.2 is now recommended
  - Updated to spout 0.8.0.rc2
- The CSV datasets generated from a SAS export is located here:
  - `\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.3.0\`
    - `shhs1-dataset-0.3.0.csv`
    - `shhs2-dataset-0.3.0.csv`
    - `shhs-cvd-dataset-0.3.0.csv`
- The SAS export now adds race, gender, and age at SHHS1 to each of the CSV datasets
  - Missing codes are now removed by default from all variables in SHHS1 and SHHS2
  - Null values (in the form of zeroes) are now removed from variables where appropriate
- Valid race domain choices were changed to be White, Black, and Other
- Valid gender values were updated from characters to numeric values for consistency across other domains
- Ethnicity has been added as a separate variable, rather than being classified within the race domain
- Visit number has been re-added to each of the BioLINCC datasets
- Categorical age has been added to SHHS1 and SHHS2 BioLINCC datasets
  - Categorical age at SHHS1 has been added to the SHHS2 dataset
- The obfuscated pptid has now been added to all datasets by default as `obf_pptid`
- Issues with data from the BioLINCC datasets for v0.3.0 (i.e. extreme values) have been grouped into a [Known Issues](https://github.com/sleepepi/shhs-data-dictionary/blob/master/KNOWNISSUES.md) list

## 0.2.0 (March 24, 2014)

- The CSV dataset generated from a SAS export is located here:
  - `\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.2.0\`
    - `shhsall-0.2.0.csv`- Moved `commonly_used` to the root of the json variable object
- Changed references of `patient` and `pt` to `participant`
- Cleaned up and removed assignment statements from calculations
- Changed description references of `#` to spelled out `number`
- Added forms JSON files and tests for variables to be able to reference the forms on which they exist
- **Gem Changes**
  - Use of Ruby 2.1.1 is now recommended
  - Updated to spout 0.7.0.beta3

## 0.1.0 (July 26, 2013)

### Changes
- The 0.1.0 branch corresponds with the Sleep Portal 0.15.0 release branch
- The SHHS SAS and SQL dataset have been cleaned to match up with the variables and domains in the SHHS Data Dictionary
  - The SQL dataset is located here:
    - `\\rfa01\bwh-sleepepi-shhs\shhs\sleep-portal-integration\_imports\2013-07-25_v0_1_0`
      - `shhs_20130725.sql`
