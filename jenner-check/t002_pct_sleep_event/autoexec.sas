/* autoexec.sas — prepended to script.sas by the runner.
 *
 * Sets the unlicensed-tier observation cap and stages a small mock
 * dataset shaped to the per-event-type count and average-duration
 * columns that the SHHS1 percent-of-sleep-time block reads in
 * scripts/prepare-shhs-for-nsrr.sas. The mock stands in for the
 * BioLINCC source dataset (libname biolincc), which is not part of
 * this repository. The AVxxx columns are average event durations in
 * seconds; the count columns are event counts.
 */
options obs=100;

data shhs1_pslp_in;
  input nsrrid slpprdp
        carbp avcarbp carop avcarop canbp avcanbp canop avcanop
        oarbp avoarbp oarop avoarop oanbp avoanbp oanop avoanop
        hrembp avhrbp hrop avhrop hnrbp avhnbp hnrop avhnop;
  datalines;
200001 360 1 18 0 0 1 20 0 0 8 22 6 24 4 19 2 21 5 23 3 25 2 18 1 20
200002 420 2 19 1 17 1 21 0 0 12 25 9 23 7 20 4 22 8 24 5 26 4 19 2 21
;
run;
