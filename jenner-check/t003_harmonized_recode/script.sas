/* script.sas — harmonized demographic recodes from
 * scripts/prepare-shhs-for-nsrr.sas (the shhs1_harmonized DATA step).
 *
 * Maps the SHHS-coded character values for gender, race, and ethnicity
 * onto the NSRR harmonized labels, with an explicit "not reported"
 * branch for missing. The three recode blocks and their formats are
 * taken verbatim from the program.
 */
data shhs1_harmonized;
  set shhs1;

*sex;
*use gender;
  format nsrr_sex $100.;
  if gender = '01' then nsrr_sex = 'male';
  else if gender = '02' then nsrr_sex = 'female';
  else if gender = '.' then nsrr_sex = 'not reported';

*race;
*use race;
    format nsrr_race $100.;
    if race = '01' then nsrr_race = 'white';
    else if race = '02' then nsrr_race = 'black or african american';
    else if race = '03' then nsrr_race = 'other';
  else if race = '.' then nsrr_race = 'not reported';

*ethnicity;
*use ethnicity;
  format nsrr_ethnicity $100.;
    if ethnicity = '01' then nsrr_ethnicity = 'hispanic or latino';
    else if ethnicity = '02' then nsrr_ethnicity = 'not hispanic or latino';
  else if ethnicity = '.' then nsrr_ethnicity = 'not reported';

  keep nsrrid nsrr_sex nsrr_race nsrr_ethnicity;
run;

proc print data=shhs1_harmonized;
run;
