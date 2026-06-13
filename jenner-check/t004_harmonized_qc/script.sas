/* script.sas — harmonized-dataset quality control from
 * scripts/prepare-shhs-for-nsrr.sas (the "checking harmonized datasets"
 * section).
 *
 * PROC MEANS scans the continuous harmonized variables for extreme
 * values; PROC FREQ tabulates the categorical harmonized variables.
 * Both PROC statements and their variable lists are taken verbatim from
 * the program (reduced to the variables present in the staged mock).
 */

/* Checking for extreme values for continuous variables */
proc means data=shhs_harmonized;
  var nsrr_age
      nsrr_bmi
      nsrr_bp_systolic
      nsrr_bp_diastolic
      nsrr_ahi_hp3u
      nsrr_ttldursp_f1;
run;

/* Checking categorical variables */
proc freq data=shhs_harmonized;
  table nsrr_sex
        nsrr_race
        nsrr_ethnicity
        nsrr_current_smoker
        nsrr_flag_spsw;
run;
