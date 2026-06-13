/* script.sas — apnea-hypopnea index (AHI) derivation from
 * scripts/prepare-shhs-for-nsrr.sas (the shhs1 base-dataset DATA step).
 *
 * The derivation logic below is taken verbatim from the program: the
 * twelve AHI variables and the central-to-obstructive event ratio,
 * computed from per-channel respiratory-event counts and the sleep
 * period duration (slpprdp). The PROC PRINT prints the headline AHI
 * variables for inspection.
 */
data shhs1_ahi;
  set shhs1_events;

  /* create new AHI variables */
  ahi_a0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                  carbp + carop + canbp + canop +
                  oarbp + oarop + oanbp + oanop) / slpprdp;
  ahi_a0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                  carbp + carop + canbp + canop +
                  oarbp + oarop + oanbp + oanop) / slpprdp;
  ahi_a0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                    carbp + carop + canbp + canop +
                    oarbp + oarop + oanbp + oanop) / slpprdp;
  ahi_a0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                    carbp + carop + canbp + canop +
                    oarbp + oarop + oanbp + oanop) / slpprdp;

  ahi_o0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                  oarbp + oarop + oanbp + oanop ) / slpprdp;
  ahi_o0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                  oarbp + oarop + oanbp + oanop ) / slpprdp;

  ahi_c0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                  carbp + carop + canbp + canop ) / slpprdp;
  ahi_c0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                  carbp + carop + canbp + canop ) / slpprdp;

  cent_obs_ratio = (carbp + carop + canbp + canop) /
                    (oarbp + oarop + oanbp + oanop);
run;

proc print data=shhs1_ahi;
  var nsrrid ahi_a0h3 ahi_a0h4 ahi_o0h3 ahi_c0h3 cent_obs_ratio;
run;
