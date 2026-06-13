/* script.sas — percent-of-sleep-time-in-respiratory-event-type
 * derivation from scripts/prepare-shhs-for-nsrr.sas (the shhs1
 * base-dataset DATA step).
 *
 * Each variable expresses the time spent in an event type as a
 * percentage of the sleep period: event counts are multiplied by their
 * average durations (seconds), summed, converted to minutes, divided by
 * the sleep period duration, and scaled by 100. The four blocks below
 * are taken verbatim from the program (central apneas, obstructive
 * apneas, all apneas, all hypopneas).
 */
data shhs1_pslp;
  set shhs1_pslp_in;

  *time in central apneas;
  pslp_ca0 =
    100 * (
    ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60))
    /
    (SLPPRDP)
    )
    ;

  *time in obstructive apneas;
  pslp_oa0 =
    100 * (
    ((((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60))
    /
    (SLPPRDP)
    )
    ;

  *time in all apneas (central + obstructive);
  pslp_ap0 =
    100 * (
    ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60) + (((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60))
    /
    (SLPPRDP)
    )
    ;

  *time in all hypopneas;
  pslp_hp0 =
    100 * (
    (((HREMBP*AVHRBP) + (HROP*AVHROP) + (HNRBP*AVHNBP) + (HNROP*AVHNOP)) / 60)
    /
    (SLPPRDP)
    )
    ;
run;

proc print data=shhs1_pslp;
  var nsrrid pslp_ca0 pslp_oa0 pslp_ap0 pslp_hp0;
run;
