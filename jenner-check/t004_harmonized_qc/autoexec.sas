/* autoexec.sas — prepended to script.sas by the runner.
 *
 * Sets the unlicensed-tier observation cap and stages a small mock
 * harmonized dataset shaped to the continuous and categorical
 * harmonized variables that the SHHS quality-control step summarizes in
 * scripts/prepare-shhs-for-nsrr.sas. It stands in for shhs_harmonized,
 * the concatenation of the visit-1 and visit-2 harmonized datasets
 * built upstream from BioLINCC source data not part of this repository.
 */
options obs=100;

data shhs_harmonized;
  length nsrr_sex nsrr_race nsrr_ethnicity nsrr_current_smoker nsrr_flag_spsw $40;
  input nsrrid visitnumber nsrr_age nsrr_bmi nsrr_bp_systolic nsrr_bp_diastolic
        nsrr_ahi_hp3u nsrr_ttldursp_f1
        nsrr_sex $ nsrr_race $ nsrr_ethnicity $ nsrr_current_smoker $ nsrr_flag_spsw $;
  datalines;
200001 1 55 27.3 128 78 12.4 360 male white not_hispanic_or_latino no full_scoring
200002 1 62 31.0 140 85 22.1 410 female black_or_african_american hispanic_or_latino yes full_scoring
200003 1 48 24.5 118 72  5.3 380 male other not_hispanic_or_latino no sleep_wake_only
200004 2 67 29.1 135 80 18.9 395 female white not_hispanic_or_latino yes full_scoring
200005 2 71 26.8 145 90 30.2 350 male white not_hispanic_or_latino no full_scoring
;
run;
