/* autoexec.sas — prepended to script.sas by the runner.
 *
 * Sets the unlicensed-tier observation cap so the run is reproducible,
 * and stages a small mock PSG event-count dataset shaped to the
 * respiratory-event columns the SHHS1 AHI-derivation block reads in
 * scripts/prepare-shhs-for-nsrr.sas. The mock stands in for the
 * BioLINCC source dataset (libname biolincc), which is not part of
 * this repository. Counts and the sleep-period duration (slpprdp) are
 * illustrative values chosen to exercise the formulas.
 */
options obs=100;

data shhs1_events;
  input nsrrid slpprdp
        hrembp3 hrop3 hnrbp3 hnrop3 hrembp4 hrop4 hnrbp4 hnrop4
        hremba3 hroa3 hnrba3 hnroa3 hremba4 hroa4 hnrba4 hnroa4
        carbp carop canbp canop oarbp oarop oanbp oanop;
  datalines;
200001 360 5 3 2 1 4 2 1 0 6 4 3 2 5 3 2 1 1 0 1 0 8 6 4 2
200002 420 8 5 4 2 6 4 3 1 9 6 5 3 7 5 4 2 2 1 1 0 12 9 7 4
200003 300 2 1 1 0 1 1 0 0 3 2 1 1 2 1 1 0 0 0 0 0 4 3 2 1
;
run;
