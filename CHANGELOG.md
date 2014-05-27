## 0.3.0

- Removed `in_shhs2_lad` variable (i.e. participant was part of SHHS2 Limited Access Dataset) as it is no longer relevant
- **Gem Changes**
  - Use of Ruby 2.1.2 is now recommended
  - Updated to spout 0.7.0
- The CSV datasets generated from a SAS export is located here:
  - `\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.3.0\`
    - `shhs1-dataset-0.3.0.beta4.csv`
    - `shhs2-dataset-0.3.0.beta4.csv`
    - `shhs-cvd-dataset-0.3.0.beta4.csv`
- The SAS export now adds race, gender, and age at SHHS1 to each of the CSV datasets
- Valid race domain choices were changed to be White, Black, and Other
- Valid gender values were updated from characters to numeric values for consistency across other domains
- Ethnicity has been added as a separate variable, rather than being classified within the race domain
- Visit number has been re-added to each of the BioLINCC datasets
- Categorical age has been added to SHHS1 and SHHS2 BioLINCC datasets
  - Categorical age at SHHS1 has been added to the SHHS2 dataset

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
