/* autoexec.sas — prepended to script.sas by the runner.
 *
 * Sets the unlicensed-tier observation cap and stages a small mock
 * dataset shaped to the coded character columns (gender, race,
 * ethnicity) that the SHHS1 harmonization block reads in
 * scripts/prepare-shhs-for-nsrr.sas. SHHS encodes these as zero-padded
 * two-character codes and missing as the literal '.'; the mock follows
 * that convention. It stands in for the derived shhs1 dataset, which is
 * built upstream from BioLINCC source data not part of this repository.
 */
options obs=100;

data shhs1;
  length gender race ethnicity $2;
  input nsrrid gender $ race $ ethnicity $;
  datalines;
200001 01 01 02
200002 02 02 01
200003 01 03 02
200004 02 01 02
200005 . . .
;
run;
