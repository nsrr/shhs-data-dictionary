## 0.2.1 (January 19, 2016)

- Backporting updates to be compatible with Spout 0.11.0

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
