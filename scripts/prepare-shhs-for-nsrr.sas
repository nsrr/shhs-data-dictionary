*******************************************************************************;
* Program           : prepare-shhs-for-nsrr.sas
* Project           : National Sleep Research Resource (sleepdata.org)
* Author            : Michael Rueschman (MR)
* Date Created      : 20170815
* Purpose           : Prepare Sleep Heart Health Study data for deposition on
*                       sleepdata.org.
* Revision History  :
*   Date      Author    Revision
*   20190528  MR        Add new variables for 0.14.0
*   20171121  MR        Add variables from AF dataset
*   20170928  MR        Finalize 0.12.0
*   20170817  MR        Bump version to 0.12.0.beta1
*   20170815  MR        Rename SAS program and add new header
*******************************************************************************;

*******************************************************************************;
* set options and libnames ;
*******************************************************************************;
  libname biolincc "\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_datasets\biolincc-master";
  libname shhs "\\rfawin\bwh-sleepepi-shhs\shhs\SHHS CD 2014.06.13\Datasets\SHHS 1";
  libname obf "\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_ids";
  libname shhspsg "\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_datasets\investigator-cd";
  libname shhsafib "\\rfawin\bwh-sleepepi-shhs\nsrr-prep\incident-afib\_datasets";

  %let release = 0.20.0.pre;

*******************************************************************************;
* pull in source data ;
*******************************************************************************;
  data obfid;
    set obf.all_ids (keep=npptid nsrrid pptidr permiss rename=(npptid=pptid));
  run;

  data obfid_c;
    set obf.all_ids (keep=pptid nsrrid permiss pptidr);
  run;

  data shhs1_investigator;
    set shhspsg.Shhs1final_13jun2014_6441(rename=(rcrdtime=rcrdtime2));

    rcrdtime = timepart(rcrdtime2);
    format rcrdtime time8.;

    *rename monitor/headbox/scorer variables to match shhs2;
    rename 
      monid51 = monitor_id
      hboxid51 = headbox_id
      scoridsn = scorer_id
      ;

    keep 
      pptid Abdodur Abdoqual Airdur Airqual Chestdur Chindur Chinqual Chstqual 
      EEG1dur EEG1qual EEG2dur EEG2qual EOGLdur EOGLqual EOGRdur EOGRqual Hrdur 
      Hrqual LightOff Oximdur Oximqual Posdur Posqual RcrdTime oximet51 scoridsn
      HBOXID51 MONID51;
  run;

  data shhs1_ecg;
    set biolincc.shhs1final_ecg_14aug2013_4260;
  run;

  data shhs1_psg;
    set biolincc.shhs1final_psg_15jan2014_5839(rename=(ppid2=pptid));
  run;

  data shhs1_other;
    set biolincc.shhs1final_15jan2014_5839(rename=(ethnic=ethnicity));
  run;

  data basedate;
    set shhs.Shhs1final_13jun2014_6441;

    stdydt = datepart(stdydtqa);
    keep pptid stdydt;
  run;

  data shhs2_investigator;
    set shhspsg.Shhs2final_15jan2014_4586_psg;

    *rename monitor/headbox/scorer variables to match shhs2;
    rename 
      scorerid = scorer_id
      ;

    keep 
      pptid STLOUTP STONSETP latreliable eogldur eogrdur chindur eeg1dur 
      eeg2dur hrdur airdur ligh chestdur abdodur oximdur queogl queogr quchin 
      queeg1 queeg2 quhr quair quchest quabdo quoxim posn scorerid;
  run;

  data shhs2_ecg;
    set biolincc.shhs2final_ecg_03mar2011_3471;
  run;

  data shhs2_psg;
    set biolincc.shhs2final_psg_15jan2014_4103;
  run;

  data shhs2_other;
    set biolincc.shhs2final_15jan2014_4103;
  run;

  data shhs_cvd_summary;
    set biolincc.shhs_status_08apr2014_5837;
  run;

  data examcycle2;
    set biolincc.followup1final_09oct2006_6441;
  run;

  data shhs_cvd_event;
    set biolincc.shhs_event_08apr2014_4869;
  run;

  data shhs_afib;
    set shhsafib.shhsafib;
  run;

  data shhs_afib_nsrrid;
    merge obfid_c (in=a) shhs_afib (in=b);
    by pptid;

    if a and permiss = 1;

    drop pptid permiss;
  run;

  data s1_psgqual;
    merge obfid_c (in=a) shhs1_investigator (in=b);
    by pptid;

    if a;

    drop pptid;
  run;

*******************************************************************************;
* create base datasets ;
*******************************************************************************;
  data shhs1;
    length nsrrid 8.;
    merge shhs1_ecg shhs1_psg shhs1_other obfid;
    by pptid;

    if age_s1 < 1 then age_category_s1 = 0;
    else if 1 =< age_s1 =< 4 then age_category_s1 = 1;
    else if 5 =< age_s1 =< 14 then age_category_s1 = 2;
    else if 15 =< age_s1 =< 24 then age_category_s1 = 3;
    else if 25 =< age_s1 =< 34 then age_category_s1 = 4;
    else if 35 =< age_s1 =< 44 then age_category_s1 = 5;
    else if 45 =< age_s1 =< 54 then age_category_s1 = 6;
    else if 55 =< age_s1 =< 64 then age_category_s1 = 7;
    else if 65 =< age_s1 =< 74 then age_category_s1 = 8;
    else if 75 =< age_s1 =< 84 then age_category_s1 = 9;
    else if 85 =< age_s1 then age_category_s1 = 10;

    if age_s1 > 89 then age_s1 = 90;

    rename overall = overall_shhs1;
    rename stroke = prev_hx_stroke;
    rename mi = prev_hx_mi;

    *convert variables from seconds to minutes;
    remlaip = remlaip / 60;
    remlaiip = remlaiip / 60;
    scremp = scremp/60;
    scstg1p = scstg1p/60;
    scstg2p = scstg2p/60;
    scstg34p = scstg34p/60;
    slpprdp = slpprdp/60;
    slplatp = slplatp/60;
    timebedp = timebedp/60;

    *calculate minsat and avgsat;
    avgsat = ( ( avsao2nh ) * ( tmstg1p + tmstg2p + tmstg34p ) + ( avsao2rh ) * ( tmremp ) ) / 100;
    *avgsat = ( ( avsao2nh ) * ( timest1p + timest2p + times34p ) + ( avsao2rh ) * ( timeremp ) ) / 100;
    if mnsao2rh le 0 then mnsao2rh = .;
    if mnsao2nh le 0 then mnsao2nh = .;
    minsat = min(mnsao2rh,mnsao2nh);

   *compute % sleep time in respiratory event types;
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

    *time in all apneas (central + obstructive) with >=3% desaturation;
    pslp_ap3 = 
      100 * (
      ((((CARBP3 * AVCARBP3) + (CAROP3 * AVCAROP3) + (CANBP3 * AVCANBP3) + (CANOP3 * AVCANOP3))/ 60) + (((OARBP3 * AVOARBP3) + (OAROP3 * AVOAROP3) + (OANBP3 * AVOANBP3) + (OANOP3 * AVOANOP3)) / 60))
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

    *time in all hypopneas with >=3% desaturation;
    pslp_hp3 = 
      100 * (
      (((HREMBP3*AVHRBP3) + (HROP3*AVHROP3) + (HNRBP3*AVHNBP3) + (HNROP3*AVHNOP3)) / 60)
      /
      (SLPPRDP)
      )
      ;

    *time in all hypopneas with >=3% desaturation or arousal;
    pslp_hp3a = 
      100 * (
      (((HREMBA3*AVHRBA3) + (HROA3*AVHROA3) + (HNRBA3*AVHNBA3) + (HNROA3*AVHNOA3)) / 60)
      /
      (SLPPRDP)
      )
      ;

    *time in all apneas + hypopneas w/ >=3% desaturation;
    pslp_ap0hp3 = 
      100 * (
      ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60) + (((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60) + (((HREMBP3*AVHRBP3) + (HROP3*AVHROP3) + (HNRBP3*AVHNBP3) + (HNROP3*AVHNOP3)) / 60))
      /
      (SLPPRDP)
      )
      ;

    *time in all apneas + hypopneas w/ >=3% desaturation or arousal;
    pslp_ap0hp3a = 
      100 * (
      ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60) + (((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60) + (((HREMBA3*AVHRBA3) + (HROA3*AVHROA3) + (HNRBA3*AVHNBA3) + (HNROA3*AVHNOA3)) / 60))
      /
      (SLPPRDP)
      )
      ;

    if yrssnr02 > 87 then yrssnr02 = .; /* should remove values of 88 or above */
    if mi2slp02 = 9999 then mi2slp02 = .;
    if minfa10 = 9999 then minfa10 = .;
    if yrsns15 = 9999 then yrsns15 = .;
    if yrsns15 = 999 then yrsns15 = .;
    if napsmn15 = 9999 then napsmn15 = .;
    if napshr15 = 9999 then napshr15 = .;
    if cigday15 = 9999 then cigday15 = .;
    if avesmk15 = 1980 then avesmk15 = .;
    if asalw15 = 9999 then asalw15 = .;
    if dias120 = 9999 or dias120 le 0 then dias120 = .;
    if dias220 = 9999 or dias220 le 0 then dias220 = .;
    if dias320 = 9999 or dias320 le 0 then dias320 = .;
    if cpap02 = 9999 then cpap02 = .;
    if hosnr02 = 9999 then hosnr02 = .;
    if hostbr02 = 9999 then hostbr02 = .;
    if issnor02 = 9999 then issnor02 = .;
    if loudsn02 = 9999 then loudsn02 = .;
    if ns1yr15 = 9999 then ns1yr15 = .;
    if smknow15 = 9999 then smknow15 = .;
    if surgsa02 = 9999 then surgsa02 = .;
    if surgtr02 = 9999 then surgtr02 = .;
    if twuwea02 = 9999 then twuwea02 = .;
    if parrptdiab = 9 then parrptdiab = .;
    if srhype = 9 then srhype = .;
    if mxsao2rh le 0 then mxsao2rh = .;
    if mxdrop5 le 0 then mxdrop5 = .;
    if mxdrop4 le 0 then mxdrop4 = .;
    if mxdrop3 le 0 then mxdrop3 = .;
    if mxdrop2 le 0 then mxdrop2 = .;
    if mxdrop le 0 then mxdrop = .;
    if mxdroa5 le 0 then mxdroa5 = .;
    if mxdroa4 le 0 then mxdroa4 = .;
    if mxdroa3 le 0 then mxdroa3 = .;
    if mxdroa2 le 0 then mxdroa2 = .;
    if mxdroa le 0 then mxdroa = .;
    if mxdrbp5 le 0 then mxdrbp5 = .;
    if mxdrbp4 le 0 then mxdrbp4 = .;
    if mxdrbp3 le 0 then mxdrbp3 = .;
    if mxdrbp2 le 0 then mxdrbp2 = .;
    if mxdrbp le 0 then mxdrbp = .;
    if mxdrba5 le 0 then mxdrba5 = .;
    if mxdrba4 le 0 then mxdrba4 = .;
    if mxdrba3 le 0 then mxdrba3 = .;
    if mxdrba2 le 0 then mxdrba2 = .;
    if mxdrba le 0 then mxdrba = .;
    if mxdnop5 le 0 then mxdnop5 = .;
    if mxdnop4 le 0 then mxdnop4 = .;
    if mxdnop3 le 0 then mxdnop3 = .;
    if mxdnop2 le 0 then mxdnop2 = .;
    if mxdnop le 0 then mxdnop = .;
    if mxdnoa5 le 0 then mxdnoa5 = .;
    if mxdnoa4 le 0 then mxdnoa4 = .;
    if mxdnoa3 le 0 then mxdnoa3 = .;
    if mxdnoa2 le 0 then mxdnoa2 = .;
    if mxdnoa le 0 then mxdnoa = .;
    if mxdnbp5 le 0 then mxdnbp5 = .;
    if mxdnbp4 le 0 then mxdnbp4 = .;
    if mxdnbp3 le 0 then mxdnbp3 = .;
    if mxdnbp2 le 0 then mxdnbp2 = .;
    if mxdnbp le 0 then mxdnbp = .;
    if mxdnba5 le 0 then mxdnba5 = .;
    if mxdnba4 le 0 then mxdnba4 = .;
    if mxdnba3 le 0 then mxdnba3 = .;
    if mxdnba2 le 0 then mxdnba2 = .;
    if mxdnba le 0 then mxdnba = .;
    if mnsao2rh le 0 then mnsao2rh = .;
    if mndrop5 le 0 then mndrop5 = .;
    if mndrop4 le 0 then mndrop4 = .;
    if mndrop3 le 0 then mndrop3 = .;
    if mndrop2 le 0 then mndrop2 = .;
    if mndrop le 0 then mndrop = .;
    if mndroa5 le 0 then mndroa5 = .;
    if mndroa4 le 0 then mndroa4 = .;
    if mndroa3 le 0 then mndroa3 = .;
    if mndroa2 le 0 then mndroa2 = .;
    if mndroa le 0 then mndroa = .;
    if mndrbp5 le 0 then mndrbp5 = .;
    if mndrbp4 le 0 then mndrbp4 = .;
    if mndrbp3 le 0 then mndrbp3 = .;
    if mndrbp2 le 0 then mndrbp2 = .;
    if mndrbp le 0 then mndrbp = .;
    if mndrba5 le 0 then mndrba5 = .;
    if mndrba4 le 0 then mndrba4 = .;
    if mndrba3 le 0 then mndrba3 = .;
    if mndrba2 le 0 then mndrba2 = .;
    if mndrba le 0 then mndrba = .;
    if mndnop5 le 0 then mndnop5 = .;
    if mndnop4 le 0 then mndnop4 = .;
    if mndnop3 le 0 then mndnop3 = .;
    if mndnop2 le 0 then mndnop2 = .;
    if mndnop le 0 then mndnop = .;
    if mndnoa5 le 0 then mndnoa5 = .;
    if mndnoa4 le 0 then mndnoa4 = .;
    if mndnoa3 le 0 then mndnoa3 = .;
    if mndnoa2 le 0 then mndnoa2 = .;
    if mndnoa le 0 then mndnoa = .;
    if mndnbp5 le 0 then mndnbp5 = .;
    if mndnbp4 le 0 then mndnbp4 = .;
    if mndnbp3 le 0 then mndnbp3 = .;
    if mndnbp2 le 0 then mndnbp2 = .;
    if mndnbp le 0 then mndnbp = .;
    if mndnba5 le 0 then mndnba5 = .;
    if mndnba4 le 0 then mndnba4 = .;
    if mndnba3 le 0 then mndnba3 = .;
    if mndnba2 le 0 then mndnba2 = .;
    if mndnba le 0 then mndnba = .;
    if avsao2rh le 0 then avsao2rh = .;
    if avdrop5 le 0 then avdrop5 = .;
    if avdrop4 le 0 then avdrop4 = .;
    if avdrop3 le 0 then avdrop3 = .;
    if avdrop2 le 0 then avdrop2 = .;
    if avdrop le 0 then avdrop = .;
    if avdroa5 le 0 then avdroa5 = .;
    if avdroa4 le 0 then avdroa4 = .;
    if avdroa3 le 0 then avdroa3 = .;
    if avdroa2 le 0 then avdroa2 = .;
    if avdroa le 0 then avdroa = .;
    if avdrbp5 le 0 then avdrbp5 = .;
    if avdrbp4 le 0 then avdrbp4 = .;
    if avdrbp3 le 0 then avdrbp3 = .;
    if avdrbp2 le 0 then avdrbp2 = .;
    if avdrbp le 0 then avdrbp = .;
    if avdrba5 le 0 then avdrba5 = .;
    if avdrba4 le 0 then avdrba4 = .;
    if avdrba3 le 0 then avdrba3 = .;
    if avdrba2 le 0 then avdrba2 = .;
    if avdrba le 0 then avdrba = .;
    if avdnop5 le 0 then avdnop5 = .;
    if avdnop4 le 0 then avdnop4 = .;
    if avdnop3 le 0 then avdnop3 = .;
    if avdnop2 le 0 then avdnop2 = .;
    if avdnop le 0 then avdnop = .;
    if avdnoa5 le 0 then avdnoa5 = .;
    if avdnoa4 le 0 then avdnoa4 = .;
    if avdnoa3 le 0 then avdnoa3 = .;
    if avdnoa2 le 0 then avdnoa2 = .;
    if avdnoa le 0 then avdnoa = .;
    if avdnbp5 le 0 then avdnbp5 = .;
    if avdnbp4 le 0 then avdnbp4 = .;
    if avdnbp3 le 0 then avdnbp3 = .;
    if avdnbp2 le 0 then avdnbp2 = .;
    if avdnbp le 0 then avdnbp = .;
    if avdnba5 le 0 then avdnba5 = .;
    if avdnba4 le 0 then avdnba4 = .;
    if avdnba3 le 0 then avdnba3 = .;
    if avdnba2 le 0 then avdnba2 = .;
    if avdnba le 0 then avdnba = .;
    if smxbroh le 0 then smxbroh = .;
    if smxbrbh le 0 then smxbrbh = .;
    if smxbnoh le 0 then smxbnoh = .;
    if smxbnbh le 0 then smxbnbh = .;
    if smnbroh le 0 then smnbroh = .;
    if smnbrbh le 0 then smnbrbh = .;
    if smnbnoh le 0 then smnbnoh = .;
    if smnbnbh le 0 then smnbnbh = .;
    if savbroh le 0 then savbroh = .;
    if savbrbh le 0 then savbrbh = .;
    if savbnoh le 0 then savbnoh = .;
    if savbnbh le 0 then savbnbh = .;
    if hmxbroh le 0 then hmxbroh = .;
    if hmxbrbh le 0 then hmxbrbh = .;
    if hmxbnoh le 0 then hmxbnoh = .;
    if hmxbnbh le 0 then hmxbnbh = .;
    if hmnbroh le 0 then hmnbroh = .;
    if hmnbrbh le 0 then hmnbrbh = .;
    if hmnbnoh le 0 then hmnbnoh = .;
    if hmnbnbh le 0 then hmnbnbh = .;
    if havbroh le 0 then havbroh = .;
    if havbrbh le 0 then havbrbh = .;
    if havbnoh le 0 then havbnoh = .;
    if havbnbh le 0 then havbnbh = .;
    if dmxbroh le 0 then dmxbroh = .;
    if dmxbrbh le 0 then dmxbrbh = .;
    if dmxbnoh le 0 then dmxbnoh = .;
    if dmxbnbh le 0 then dmxbnbh = .;
    if dmnbroh le 0 then dmnbroh = .;
    if dmnbrbh le 0 then dmnbrbh = .;
    if dmnbnoh le 0 then dmnbnoh = .;
    if dmnbnbh le 0 then dmnbnbh = .;
    if davbroh le 0 then davbroh = .;
    if davbrbh le 0 then davbrbh = .;
    if davbnoh le 0 then davbnoh = .;
    if davbnbh le 0 then davbnbh = .;
    if amxbroh le 0 then amxbroh = .;
    if amxbrbh le 0 then amxbrbh = .;
    if amxbnoh le 0 then amxbnoh = .;
    if amxbnbh le 0 then amxbnbh = .;
    if amnbroh le 0 then amnbroh = .;
    if amnbrbh le 0 then amnbrbh = .;
    if amnbnoh le 0 then amnbnoh = .;
    if amnbnbh le 0 then amnbnbh = .;
    if aavbroh le 0 then aavbroh = .;
    if aavbrbh le 0 then aavbrbh = .;
    if aavbnoh le 0 then aavbnoh = .;
    if aavbnbh le 0 then aavbnbh = .;
    if mxhrop5 le 0 then mxhrop5 = .;
    if mxhrop4 le 0 then mxhrop4 = .;
    if mxhrop3 le 0 then mxhrop3 = .;
    if mxhrop2 le 0 then mxhrop2 = .;
    if mxhrop le 0 then mxhrop = .;
    if mxhroa5 le 0 then mxhroa5 = .;
    if mxhroa4 le 0 then mxhroa4 = .;
    if mxhroa3 le 0 then mxhroa3 = .;
    if mxhroa2 le 0 then mxhroa2 = .;
    if mxhroa le 0 then mxhroa = .;
    if mxhrbp5 le 0 then mxhrbp5 = .;
    if mxhrbp4 le 0 then mxhrbp4 = .;
    if mxhrbp3 le 0 then mxhrbp3 = .;
    if mxhrbp2 le 0 then mxhrbp2 = .;
    if mxhrbp le 0 then mxhrbp = .;
    if mxhrba5 le 0 then mxhrba5 = .;
    if mxhrba4 le 0 then mxhrba4 = .;
    if mxhrba3 le 0 then mxhrba3 = .;
    if mxhrba2 le 0 then mxhrba2 = .;
    if mxhrba le 0 then mxhrba = .;
    if mxhnop5 le 0 then mxhnop5 = .;
    if mxhnop4 le 0 then mxhnop4 = .;
    if mxhnop3 le 0 then mxhnop3 = .;
    if mxhnop2 le 0 then mxhnop2 = .;
    if mxhnop le 0 then mxhnop = .;
    if mxhnoa5 le 0 then mxhnoa5 = .;
    if mxhnoa4 le 0 then mxhnoa4 = .;
    if mxhnoa3 le 0 then mxhnoa3 = .;
    if mxhnoa2 le 0 then mxhnoa2 = .;
    if mxhnoa le 0 then mxhnoa = .;
    if mxhnbp5 le 0 then mxhnbp5 = .;
    if mxhnbp4 le 0 then mxhnbp4 = .;
    if mxhnbp3 le 0 then mxhnbp3 = .;
    if mxhnbp2 le 0 then mxhnbp2 = .;
    if mxhnbp le 0 then mxhnbp = .;
    if mxhnba5 le 0 then mxhnba5 = .;
    if mxhnba4 le 0 then mxhnba4 = .;
    if mxhnba3 le 0 then mxhnba3 = .;
    if mxhnba2 le 0 then mxhnba2 = .;
    if mxhnba le 0 then mxhnba = .;
    if mnhrop5 le 0 then mnhrop5 = .;
    if mnhrop4 le 0 then mnhrop4 = .;
    if mnhrop3 le 0 then mnhrop3 = .;
    if mnhrop2 le 0 then mnhrop2 = .;
    if mnhrop le 0 then mnhrop = .;
    if mnhroa5 le 0 then mnhroa5 = .;
    if mnhroa4 le 0 then mnhroa4 = .;
    if mnhroa3 le 0 then mnhroa3 = .;
    if mnhroa2 le 0 then mnhroa2 = .;
    if mnhroa le 0 then mnhroa = .;
    if mnhrbp5 le 0 then mnhrbp5 = .;
    if mnhrbp4 le 0 then mnhrbp4 = .;
    if mnhrbp3 le 0 then mnhrbp3 = .;
    if mnhrbp2 le 0 then mnhrbp2 = .;
    if mnhrbp le 0 then mnhrbp = .;
    if mnhrba5 le 0 then mnhrba5 = .;
    if mnhrba4 le 0 then mnhrba4 = .;
    if mnhrba3 le 0 then mnhrba3 = .;
    if mnhrba2 le 0 then mnhrba2 = .;
    if mnhrba le 0 then mnhrba = .;
    if mnhnop3 le 0 then mnhnop3 = .;
    if mnhnop2 le 0 then mnhnop2 = .;
    if mnhnop le 0 then mnhnop = .;
    if mnhnoa5 le 0 then mnhnoa5 = .;
    if mnhnoa4 le 0 then mnhnoa4 = .;
    if mnhnoa3 le 0 then mnhnoa3 = .;
    if mnhnoa2 le 0 then mnhnoa2 = .;
    if mnhnoa le 0 then mnhnoa = .;
    if mnhnbp5 le 0 then mnhnbp5 = .;
    if mnhnbp4 le 0 then mnhnbp4 = .;
    if mnhnbp3 le 0 then mnhnbp3 = .;
    if mnhnbp2 le 0 then mnhnbp2 = .;
    if mnhnbp le 0 then mnhnbp = .;
    if mnhnba5 le 0 then mnhnba5 = .;
    if mnhnba4 le 0 then mnhnba4 = .;
    if mnhnba3 le 0 then mnhnba3 = .;
    if mnhnba2 le 0 then mnhnba2 = .;
    if mnhnba le 0 then mnhnba = .;
    if avhrop5 le 0 then avhrop5 = .;
    if avhrop4 le 0 then avhrop4 = .;
    if avhrop3 le 0 then avhrop3 = .;
    if avhrop2 le 0 then avhrop2 = .;
    if avhrop le 0 then avhrop = .;
    if avhroa5 le 0 then avhroa5 = .;
    if avhroa4 le 0 then avhroa4 = .;
    if avhroa3 le 0 then avhroa3 = .;
    if avhroa2 le 0 then avhroa2 = .;
    if avhroa le 0 then avhroa = .;
    if avhrbp5 le 0 then avhrbp5 = .;
    if avhrbp4 le 0 then avhrbp4 = .;
    if avhrbp3 le 0 then avhrbp3 = .;
    if avhrbp2 le 0 then avhrbp2 = .;
    if avhrbp le 0 then avhrbp = .;
    if avhrba5 le 0 then avhrba5 = .;
    if avhrba4 le 0 then avhrba4 = .;
    if avhrba3 le 0 then avhrba3 = .;
    if avhrba2 le 0 then avhrba2 = .;
    if avhrba le 0 then avhrba = .;
    if avhnop5 le 0 then avhnop5 = .;
    if avhnop4 le 0 then avhnop4 = .;
    if avhnop3 le 0 then avhnop3 = .;
    if avhnop2 le 0 then avhnop2 = .;
    if avhnop le 0 then avhnop = .;
    if avhnoa5 le 0 then avhnoa5 = .;
    if avhnoa4 le 0 then avhnoa4 = .;
    if avhnoa3 le 0 then avhnoa3 = .;
    if avhnoa2 le 0 then avhnoa2 = .;
    if avhnoa le 0 then avhnoa = .;
    if avhnbp5 le 0 then avhnbp5 = .;
    if avhnbp4 le 0 then avhnbp4 = .;
    if avhnbp3 le 0 then avhnbp3 = .;
    if avhnbp2 le 0 then avhnbp2 = .;
    if avhnbp le 0 then avhnbp = .;
    if avhnba5 le 0 then avhnba5 = .;
    if avhnba4 le 0 then avhnba4 = .;
    if avhnba3 le 0 then avhnba3 = .;
    if avhnba2 le 0 then avhnba2 = .;
    if avhnba le 0 then avhnba = .;
    if mxoarop5 le 0 then mxoarop5 = .;
    if mxoarop4 le 0 then mxoarop4 = .;
    if mxoarop3 le 0 then mxoarop3 = .;
    if mxoarop2 le 0 then mxoarop2 = .;
    if mxoarop le 0 then mxoarop = .;
    if mxoaroa5 le 0 then mxoaroa5 = .;
    if mxoaroa4 le 0 then mxoaroa4 = .;
    if mxoaroa3 le 0 then mxoaroa3 = .;
    if mxoaroa2 le 0 then mxoaroa2 = .;
    if mxoaroa le 0 then mxoaroa = .;
    if mxoarbp5 le 0 then mxoarbp5 = .;
    if mxoarbp4 le 0 then mxoarbp4 = .;
    if mxoarbp3 le 0 then mxoarbp3 = .;
    if mxoarbp2 le 0 then mxoarbp2 = .;
    if mxoarbp le 0 then mxoarbp = .;
    if mxoarba5 le 0 then mxoarba5 = .;
    if mxoarba4 le 0 then mxoarba4 = .;
    if mxoarba3 le 0 then mxoarba3 = .;
    if mxoarba2 le 0 then mxoarba2 = .;
    if mxoarba le 0 then mxoarba = .;
    if mxoanop5 le 0 then mxoanop5 = .;
    if mxoanop4 le 0 then mxoanop4 = .;
    if mxoanop3 le 0 then mxoanop3 = .;
    if mxoanop2 le 0 then mxoanop2 = .;
    if mxoanop le 0 then mxoanop = .;
    if mxoanoa5 le 0 then mxoanoa5 = .;
    if mxoanoa4 le 0 then mxoanoa4 = .;
    if mxoanoa3 le 0 then mxoanoa3 = .;
    if mxoanoa2 le 0 then mxoanoa2 = .;
    if mxoanoa le 0 then mxoanoa = .;
    if mxoanbp5 le 0 then mxoanbp5 = .;
    if mxoanbp4 le 0 then mxoanbp4 = .;
    if mxoanbp3 le 0 then mxoanbp3 = .;
    if mxoanbp2 le 0 then mxoanbp2 = .;
    if mxoanbp le 0 then mxoanbp = .;
    if mxoanba5 le 0 then mxoanba5 = .;
    if mxoanba4 le 0 then mxoanba4 = .;
    if mxoanba3 le 0 then mxoanba3 = .;
    if mxoanba2 le 0 then mxoanba2 = .;
    if mxoanba le 0 then mxoanba = .;
    if mnoarop5 le 0 then mnoarop5 = .;
    if mnoarop4 le 0 then mnoarop4 = .;
    if mnoarop3 le 0 then mnoarop3 = .;
    if mnoarop2 le 0 then mnoarop2 = .;
    if mnoarop le 0 then mnoarop = .;
    if mnoaroa5 le 0 then mnoaroa5 = .;
    if mnoaroa4 le 0 then mnoaroa4 = .;
    if mnoaroa3 le 0 then mnoaroa3 = .;
    if mnoaroa2 le 0 then mnoaroa2 = .;
    if mnoaroa le 0 then mnoaroa = .;
    if mnoarbp5 le 0 then mnoarbp5 = .;
    if mnoarbp4 le 0 then mnoarbp4 = .;
    if mnoarbp3 le 0 then mnoarbp3 = .;
    if mnoarbp2 le 0 then mnoarbp2 = .;
    if mnoarbp le 0 then mnoarbp = .;
    if mnoarba5 le 0 then mnoarba5 = .;
    if mnoarba4 le 0 then mnoarba4 = .;
    if mnoarba3 le 0 then mnoarba3 = .;
    if mnoarba2 le 0 then mnoarba2 = .;
    if mnoarba le 0 then mnoarba = .;
    if mnoanop5 le 0 then mnoanop5 = .;
    if mnoanop4 le 0 then mnoanop4 = .;
    if mnoanop3 le 0 then mnoanop3 = .;
    if mnoanop2 le 0 then mnoanop2 = .;
    if mnoanop le 0 then mnoanop = .;
    if mnoanoa5 le 0 then mnoanoa5 = .;
    if mnoanoa4 le 0 then mnoanoa4 = .;
    if mnoanoa3 le 0 then mnoanoa3 = .;
    if mnoanoa2 le 0 then mnoanoa2 = .;
    if mnoanoa le 0 then mnoanoa = .;
    if mnoanbp5 le 0 then mnoanbp5 = .;
    if mnoanbp4 le 0 then mnoanbp4 = .;
    if mnoanbp3 le 0 then mnoanbp3 = .;
    if mnoanbp2 le 0 then mnoanbp2 = .;
    if mnoanbp le 0 then mnoanbp = .;
    if mnoanba5 le 0 then mnoanba5 = .;
    if mnoanba4 le 0 then mnoanba4 = .;
    if mnoanba3 le 0 then mnoanba3 = .;
    if mnoanba2 le 0 then mnoanba2 = .;
    if mnoanba le 0 then mnoanba = .;
    if avoarop5 le 0 then avoarop5 = .;
    if avoarop4 le 0 then avoarop4 = .;
    if avoarop3 le 0 then avoarop3 = .;
    if avoarop2 le 0 then avoarop2 = .;
    if avoarop le 0 then avoarop = .;
    if avoaroa5 le 0 then avoaroa5 = .;
    if avoaroa4 le 0 then avoaroa4 = .;
    if avoaroa3 le 0 then avoaroa3 = .;
    if avoaroa2 le 0 then avoaroa2 = .;
    if avoaroa le 0 then avoaroa = .;
    if avoarbp5 le 0 then avoarbp5 = .;
    if avoarbp4 le 0 then avoarbp4 = .;
    if avoarbp3 le 0 then avoarbp3 = .;
    if avoarbp2 le 0 then avoarbp2 = .;
    if avoarbp le 0 then avoarbp = .;
    if avoarba5 le 0 then avoarba5 = .;
    if avoarba4 le 0 then avoarba4 = .;
    if avoarba3 le 0 then avoarba3 = .;
    if avoarba2 le 0 then avoarba2 = .;
    if avoarba le 0 then avoarba = .;
    if avoanop5 le 0 then avoanop5 = .;
    if avoanop4 le 0 then avoanop4 = .;
    if avoanop3 le 0 then avoanop3 = .;
    if avoanop2 le 0 then avoanop2 = .;
    if avoanop le 0 then avoanop = .;
    if avoanoa5 le 0 then avoanoa5 = .;
    if avoanoa4 le 0 then avoanoa4 = .;
    if avoanoa3 le 0 then avoanoa3 = .;
    if avoanoa2 le 0 then avoanoa2 = .;
    if avoanoa le 0 then avoanoa = .;
    if avoanbp5 le 0 then avoanbp5 = .;
    if avoanbp4 le 0 then avoanbp4 = .;
    if avoanbp3 le 0 then avoanbp3 = .;
    if avoanbp2 le 0 then avoanbp2 = .;
    if avoanbp le 0 then avoanbp = .;
    if avoanba5 le 0 then avoanba5 = .;
    if avoanba4 le 0 then avoanba4 = .;
    if avoanba3 le 0 then avoanba3 = .;
    if avoanba2 le 0 then avoanba2 = .;
    if avoanba le 0 then avoanba = .;
    if mxcarop5 le 0 then mxcarop5 = .;
    if mxcarop4 le 0 then mxcarop4 = .;
    if mxcarop3 le 0 then mxcarop3 = .;
    if mxcarop2 le 0 then mxcarop2 = .;
    if mxcarop le 0 then mxcarop = .;
    if mxcaroa5 le 0 then mxcaroa5 = .;
    if mxcaroa4 le 0 then mxcaroa4 = .;
    if mxcaroa3 le 0 then mxcaroa3 = .;
    if mxcaroa2 le 0 then mxcaroa2 = .;
    if mxcaroa le 0 then mxcaroa = .;
    if mxcarbp5 le 0 then mxcarbp5 = .;
    if mxcarbp4 le 0 then mxcarbp4 = .;
    if mxcarbp3 le 0 then mxcarbp3 = .;
    if mxcarbp2 le 0 then mxcarbp2 = .;
    if mxcarbp le 0 then mxcarbp = .;
    if mxcarba5 le 0 then mxcarba5 = .;
    if mxcarba4 le 0 then mxcarba4 = .;
    if mxcarba3 le 0 then mxcarba3 = .;
    if mxcarba2 le 0 then mxcarba2 = .;
    if mxcarba le 0 then mxcarba = .;
    if mxcanop5 le 0 then mxcanop5 = .;
    if mxcanop4 le 0 then mxcanop4 = .;
    if mxcanop3 le 0 then mxcanop3 = .;
    if mxcanop2 le 0 then mxcanop2 = .;
    if mxcanop le 0 then mxcanop = .;
    if mxcanoa5 le 0 then mxcanoa5 = .;
    if mxcanoa4 le 0 then mxcanoa4 = .;
    if mxcanoa3 le 0 then mxcanoa3 = .;
    if mxcanoa2 le 0 then mxcanoa2 = .;
    if mxcanoa le 0 then mxcanoa = .;
    if mxcanbp5 le 0 then mxcanbp5 = .;
    if mxcanbp4 le 0 then mxcanbp4 = .;
    if mxcanbp3 le 0 then mxcanbp3 = .;
    if mxcanbp2 le 0 then mxcanbp2 = .;
    if mxcanbp le 0 then mxcanbp = .;
    if mxcanba5 le 0 then mxcanba5 = .;
    if mxcanba4 le 0 then mxcanba4 = .;
    if mxcanba3 le 0 then mxcanba3 = .;
    if mxcanba2 le 0 then mxcanba2 = .;
    if mxcanba le 0 then mxcanba = .;
    if mncarop5 le 0 then mncarop5 = .;
    if mncarop4 le 0 then mncarop4 = .;
    if mncarop3 le 0 then mncarop3 = .;
    if mncarop2 le 0 then mncarop2 = .;
    if mncarop le 0 then mncarop = .;
    if mncaroa5 le 0 then mncaroa5 = .;
    if mncaroa4 le 0 then mncaroa4 = .;
    if mncaroa3 le 0 then mncaroa3 = .;
    if mncaroa2 le 0 then mncaroa2 = .;
    if mncaroa le 0 then mncaroa = .;
    if mncarbp5 le 0 then mncarbp5 = .;
    if mncarbp4 le 0 then mncarbp4 = .;
    if mncarbp3 le 0 then mncarbp3 = .;
    if mncarbp2 le 0 then mncarbp2 = .;
    if mncarbp le 0 then mncarbp = .;
    if mncarba5 le 0 then mncarba5 = .;
    if mncarba4 le 0 then mncarba4 = .;
    if mncarba3 le 0 then mncarba3 = .;
    if mncarba2 le 0 then mncarba2 = .;
    if mncarba le 0 then mncarba = .;
    if mncanop5 le 0 then mncanop5 = .;
    if mncanop4 le 0 then mncanop4 = .;
    if mncanop3 le 0 then mncanop3 = .;
    if mncanop2 le 0 then mncanop2 = .;
    if mncanop le 0 then mncanop = .;
    if mncanoa5 le 0 then mncanoa5 = .;
    if mncanoa4 le 0 then mncanoa4 = .;
    if mncanoa3 le 0 then mncanoa3 = .;
    if mncanoa2 le 0 then mncanoa2 = .;
    if mncanoa le 0 then mncanoa = .;
    if mncanbp5 le 0 then mncanbp5 = .;
    if mncanbp4 le 0 then mncanbp4 = .;
    if mncanbp3 le 0 then mncanbp3 = .;
    if mncanbp2 le 0 then mncanbp2 = .;
    if mncanbp le 0 then mncanbp = .;
    if mncanba5 le 0 then mncanba5 = .;
    if mncanba4 le 0 then mncanba4 = .;
    if mncanba3 le 0 then mncanba3 = .;
    if mncanba2 le 0 then mncanba2 = .;
    if mncanba le 0 then mncanba = .;
    if avcarop5 le 0 then avcarop5 = .;
    if avcarop4 le 0 then avcarop4 = .;
    if avcarop3 le 0 then avcarop3 = .;
    if avcarop2 le 0 then avcarop2 = .;
    if avcarop le 0 then avcarop = .;
    if avcaroa5 le 0 then avcaroa5 = .;
    if avcaroa4 le 0 then avcaroa4 = .;
    if avcaroa3 le 0 then avcaroa3 = .;
    if avcaroa2 le 0 then avcaroa2 = .;
    if avcaroa le 0 then avcaroa = .;
    if avcarbp5 le 0 then avcarbp5 = .;
    if avcarbp4 le 0 then avcarbp4 = .;
    if avcarbp3 le 0 then avcarbp3 = .;
    if avcarbp2 le 0 then avcarbp2 = .;
    if avcarbp le 0 then avcarbp = .;
    if avcarba5 le 0 then avcarba5 = .;
    if avcarba4 le 0 then avcarba4 = .;
    if avcarba3 le 0 then avcarba3 = .;
    if avcarba2 le 0 then avcarba2 = .;
    if avcarba le 0 then avcarba = .;
    if avcanop5 le 0 then avcanop5 = .;
    if avcanop4 le 0 then avcanop4 = .;
    if avcanop3 le 0 then avcanop3 = .;
    if avcanop2 le 0 then avcanop2 = .;
    if avcanop le 0 then avcanop = .;
    if avcanoa5 le 0 then avcanoa5 = .;
    if avcanoa4 le 0 then avcanoa4 = .;
    if avcanoa3 le 0 then avcanoa3 = .;
    if avcanoa2 le 0 then avcanoa2 = .;
    if avcanoa le 0 then avcanoa = .;
    if avcanbp5 le 0 then avcanbp5 = .;
    if avcanbp4 le 0 then avcanbp4 = .;
    if avcanbp3 le 0 then avcanbp3 = .;
    if avcanbp2 le 0 then avcanbp2 = .;
    if avcanbp le 0 then avcanbp = .;
    if avcanba5 le 0 then avcanba5 = .;
    if avcanba4 le 0 then avcanba4 = .;
    if avcanba3 le 0 then avcanba3 = .;
    if avcanba2 le 0 then avcanba2 = .;
    if avcanba le 0 then avcanba = .;
    if diasbp le 0 then diasbp = .;
    if mnsao2nh le 0 then mnsao2nh = .;
    if tfaweh02 > 12 then tfaweh02 = tfaweh02 - 12;
    if fev1 le 0 then fev1 = .;
    if fvc le 0 then fvc = .;
    if mh_s1 le 0 then mh_s1 = .;
    if re_s1 le 0 then re_s1 = .;
    if sf_s1 le 0 then sf_s1 = .;
    if gh_s1 le 0 then gh_s1 = .;
    if bp_s1 le 0 then bp_s1 = .;
    if pf_s1 le 0 then pf_s1 = .;
    if vt_s1 le 0 then vt_s1 = .;
    if systbp le 0 then systbp = .;
    if mndnba5 = 255 then mndnba5 = .;
    if mndnba4 = 255 then mndnba4 = .;
    if mndnba3 = 255 then mndnba3 = .;
    if mndnba2 = 255 then mndnba2 = .;
    if mndnba = 255 then mndnba = .;
    if mndnoa5 = 255 then mndnoa5 = .;
    if mndnoa4 = 255 then mndnoa4 = .;
    if mndnoa3 = 255 then mndnoa3 = .;
    if mndnoa2 = 255 then mndnoa2 = .;
    if mndnoa = 255 then mndnoa = .;
    if mndrba5 = 255 then mndrba5 = .;
    if mndrba4 = 255 then mndrba4 = .;
    if mndrba3 = 255 then mndrba3 = .;
    if mndrba = 255 then mndrba = .;
    if mndroa5 = 255 then mndroa5 = .;
    if mndroa4 = 255 then mndroa4 = .;
    if mndroa = 255 then mndroa = .;
    if mndnbp = 255 then mndnbp = .;

    visitnumber = 1;

    /* corrects an erroneous value in the SHHS1 data*/
    if tfawea02 = 10 then tfawea02 = 2;

    /* only keep subjects who gave permission for data to be shared */
    if permiss = 1;

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
    ahi_o0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_o0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;

    ahi_c0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                    carbp + carop + canbp + canop ) / slpprdp;

    cent_obs_ratio = (carbp + carop + canbp + canop) /
                      (oarbp + oarop + oanbp + oanop);
    cent_obs_ratioa = (carba + caroa + canba + canoa) /
                      (oarba + oaroa + oanba + oanoa);

    drop
      uenrbp--UEROP5A
      repsgpptid
      responqa
      blpsgdate
      permiss
      ecgdt
      /* removed duplicate variables for 0.16.0 */
      oahi
      pctlt75
      pctlt80
      pctlt85
      pctlt90
      slp_eff
      slp_lat
      slp_rdi
      slp_time
      time_bed
      tmremp
      tmstg34p
      tmstg1p
      tmstg2p
      slptime
      minremp
      minstg1p
      minstg2p
      mnstg34p
      scremp
      scstg1p
      scstg2p
      scstg34p
      rem_lat1
      losao2nr
      losao2r
      sao2nrem
      sao2rem
      /* end set of removed variables for 0.16.0 */
      prerdi /* scorer-recorded AHI, not necesary */
      ;
  run;

  proc sort data=s1_psgqual;
    by nsrrid;
  run;

  data shhs1;
    merge shhs1(in=a) s1_psgqual;
    by nsrrid;

    if a;

    drop permiss;
  run;

  proc import datafile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\start-date-of-recording\nsrr-shhs1-edf-start-date-of-recording-month.csv"
    out=shhs1_psgmonth_in
    dbms=csv
    replace;
  run;

  data shhs1_psgmonth;
    set shhs1_psgmonth_in;

    keep
      nsrrid
      psg_month
      ;
  run;

  data shhs1;
    merge shhs1 shhs1_psgmonth;
    by nsrrid;
  run;

  data shhs2;
    merge shhs2_ecg shhs2_psg shhs2_other;
    by pptid;
  run;

  data shhs_demo;
    merge shhs1 obfid;
    by pptid;

    if age_s1 < 1 then age_category_s1 = 0;
    else if 1 =< age_s1 =< 4 then age_category_s1 = 1;
    else if 5 =< age_s1 =< 14 then age_category_s1 = 2;
    else if 15 =< age_s1 =< 24 then age_category_s1 = 3;
    else if 25 =< age_s1 =< 34 then age_category_s1 = 4;
    else if 35 =< age_s1 =< 44 then age_category_s1 = 5;
    else if 45 =< age_s1 =< 54 then age_category_s1 = 6;
    else if 55 =< age_s1 =< 64 then age_category_s1 = 7;
    else if 65 =< age_s1 =< 74 then age_category_s1 = 8;
    else if 75 =< age_s1 =< 84 then age_category_s1 = 9;
    else if 85 =< age_s1 then age_category_s1 = 10;
    if age_s1 > 89 then age_s1 = 90;

    keep nsrrid race gender age_s1;
  run;

  data shhs_exam2;
    length nsrrid 8.;
    merge examcycle2(in=a) obfid_c(in=b) basedate;
    by pptid;

    if a and b;

    /*strip PHI out of text variables*/
    if nsrrid in (200045,200091,200187,200202,200222,200310,200450,200467,200509,200543,200546,200553,200590,200632,200682,200722,200727,200752,200810,200817,200910,200948,201040,201041,201073,201098,201151,201177,201212,201277,201310,201358,201452,201459,201495,201506,201559,201612,201621,201647,201800,201845,202048,202104,202259,202274,202305,202321,202323,202522,202544,202559,202566,202612,202633,202666,202684,202702,202744,202773,202780,202840,202874,202881,202896,202919,202957,202978,202991,203024,203031,203048,203050,203079,203107,203165,203166,203205,203209,203239,203242,203457,203472,203505,203539,203556,203579,203582,203605,203606,203643,203651,203662,203671,203676,203725,203733,203746,203749,203766,203784,203857,203891,203905,203961,204105,204785,205002,205007,205014,205028,205052,205199,205215,205315,205464,205477,205615,205689,205707) then comments = "";

    if nsrrid = 205730 then snspcother = "";
    if nsrrid = 205319 then spcothernottreated = "";
    if nsrrid in (200646,201382) then spcsleepdisorder = "";
    if nsrrid in (200098,200119,200158,200346,200348,200349,200799,200811,202084) then statusother = "";
    if diastolic1 = 0 then diastolic1 = .;
    if diastolic2 = 0 then diastolic2 = .;
    if diastolic3 = 0 then diastolic3 = .;
    if avgdias = 0 then avgdias = .;
    avgdias = mean(diastolic1,diastolic2,diastolic3);

    /*deidentify date variables*/
    callDt2 = datepart(callDt) - stdydt;
    completedDt_scr2 = datepart(completedDt_scr) - stdydt;
    ReadIn_scr2 = datepart(ReadIn_scr) - stdydt;
    formDt2 = datepart(formDt) - stdydt;
    intRevDt2 = datepart(intRevDt) - stdydt;
    ReadIn_slpsym2 = datepart(ReadIn_slpsym) - stdydt;
    visitDt2 = datepart(visitDt) - stdydt;
    bpTime2 = datepart(bpTime) - stdydt;
    Midt2 = datepart(Midt) - stdydt;
    StrokeTIAdt2 = datepart(StrokeTIAdt) - stdydt;
    CHFdt2 = datepart(CHFdt) - stdydt;
    CABGPTCAdt2 = datepart(CABGPTCAdt) - stdydt;
    carotidEndDt2 = datepart(carotidEndDt) - stdydt;
    completedDt_stat2 = datepart(completedDt_stat) - stdydt;
    ReadIn_stat2 = datepart(ReadIn_stat) - stdydt;

    /*rename key variable that overlaps variable from CVD dataset*/
    rename mi = mi_priorexam;

    /*compute interim epworth total*/
    ess_interim = sum(sitread-1,watchtv-1,sitpublic-1,ridecar-1,resting-1,sittalk-1,sitafterlunch-1,stoppedcar-1);

    visitnumber = 4;

    if nsrrid = . then delete;

    drop pptid shhs clinic omni permiss intRevID bpTechID callDt completedDt_scr ReadIn_scr formDt intRevDt ReadIn_slpsym visitDt bpTime Midt StrokeTIAdt CHFdt CABGPTCAdt carotidEndDt completedDt_stat ReadIn_stat stdydt statfollowup slpsymfollowup;
  run;

  proc sort data=shhs_exam2;
    by nsrrid;
  run;

  proc sort data=shhs_demo;
    by nsrrid;
  run;

  data shhs_exam2;
    merge shhs_exam2 (in=a) shhs_demo;
    by nsrrid;

    if a;

    rename callDt2=callDt completedDt_scr2=completedDt_scr ReadIn_scr2=ReadIn_scr formDt2=formDt intRevDt2=intRevDt ReadIn_slpsym2=ReadIn_slpsym visitDt2=visitDt bpTime2=bpTime Midt2=Midt StrokeTIAdt2=StrokeTIAdt CHFdt2=CHFdt CABGPTCAdt2=CABGPTCAdt carotidEndDt2=carotidEndDt completedDt_stat2=completedDt_stat ReadIn_stat2=ReadIn_stat;

  run;

  data s2_psgqual;
    merge obfid_c(in=a) shhs2_investigator(in=b);
    by pptid;

    if a;

    drop pptid;
  run;

  data shhs2;
    length nsrrid 8.;
    merge shhs2(in=a) obfid;
    by pptid;

    if a;

    if age_s2 < 1 then age_category_s2 = 0;
    else if 1 =< age_s2 =< 4 then age_category_s2 = 1;
    else if 5 =< age_s2 =< 14 then age_category_s2 = 2;
    else if 15 =< age_s2 =< 24 then age_category_s2 = 3;
    else if 25 =< age_s2 =< 34 then age_category_s2 = 4;
    else if 35 =< age_s2 =< 44 then age_category_s2 = 5;
    else if 45 =< age_s2 =< 54 then age_category_s2 = 6;
    else if 55 =< age_s2 =< 64 then age_category_s2 = 7;
    else if 65 =< age_s2 =< 74 then age_category_s2 = 8;
    else if 75 =< age_s2 =< 84 then age_category_s2 = 9;
    else if 85 =< age_s2 then age_category_s2 = 10;

    rename insln2 = insuln2;
    rename prgstn2 = progst2;
    rename prmrn2 = premar2;
    rename overall = overall_shhs2;

   *compute % sleep time in respiratory event types;
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

    *time in all apneas (central + obstructive) with >=3% desaturation;
    pslp_ap3 = 
      100 * (
      ((((CARBP3 * AVCARBP3) + (CAROP3 * AVCAROP3) + (CANBP3 * AVCANBP3) + (CANOP3 * AVCANOP3))/ 60) + (((OARBP3 * AVOARBP3) + (OAROP3 * AVOAROP3) + (OANBP3 * AVOANBP3) + (OANOP3 * AVOANOP3)) / 60))
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

    *time in all hypopneas with >=3% desaturation;
    pslp_hp3 = 
      100 * (
      (((HREMBP3*AVHRBP3) + (HROP3*AVHROP3) + (HNRBP3*AVHNBP3) + (HNROP3*AVHNOP3)) / 60)
      /
      (SLPPRDP)
      )
      ;

    *time in all hypopneas with >=3% desaturation or arousal;
    pslp_hp3a = 
      100 * (
      (((HREMBA3*AVHRBA3) + (HROA3*AVHROA3) + (HNRBA3*AVHNBA3) + (HNROA3*AVHNOA3)) / 60)
      /
      (SLPPRDP)
      )
      ;

    *time in all apneas + hypopneas w/ >=3% desaturation;
    pslp_ap0hp3 = 
      100 * (
      ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60) + (((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60) + (((HREMBP3*AVHRBP3) + (HROP3*AVHROP3) + (HNRBP3*AVHNBP3) + (HNROP3*AVHNOP3)) / 60))
      /
      (SLPPRDP)
      )
      ;

    *time in all apneas + hypopneas w/ >=3% desaturation or arousal;
    pslp_ap0hp3a = 
      100 * (
      ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60) + (((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60) + (((HREMBA3*AVHRBA3) + (HROA3*AVHROA3) + (HNRBA3*AVHNBA3) + (HNROA3*AVHNOA3)) / 60))
      /
      (SLPPRDP)
      )
      ;

    if mxsao2rh le 0 then mxsao2rh = .;
    if mxdrop5 le 0 then mxdrop5 = .;
    if mxdrop4 le 0 then mxdrop4 = .;
    if mxdrop3 le 0 then mxdrop3 = .;
    if mxdrop2 le 0 then mxdrop2 = .;
    if mxdrop le 0 then mxdrop = .;
    if mxdroa5 le 0 then mxdroa5 = .;
    if mxdroa4 le 0 then mxdroa4 = .;
    if mxdroa3 le 0 then mxdroa3 = .;
    if mxdroa2 le 0 then mxdroa2 = .;
    if mxdroa le 0 then mxdroa = .;
    if mxdrbp5 le 0 then mxdrbp5 = .;
    if mxdrbp4 le 0 then mxdrbp4 = .;
    if mxdrbp3 le 0 then mxdrbp3 = .;
    if mxdrbp2 le 0 then mxdrbp2 = .;
    if mxdrbp le 0 then mxdrbp = .;
    if mxdrba5 le 0 then mxdrba5 = .;
    if mxdrba4 le 0 then mxdrba4 = .;
    if mxdrba3 le 0 then mxdrba3 = .;
    if mxdrba2 le 0 then mxdrba2 = .;
    if mxdrba le 0 then mxdrba = .;
    if mxdnop5 le 0 then mxdnop5 = .;
    if mxdnop4 le 0 then mxdnop4 = .;
    if mxdnop3 le 0 then mxdnop3 = .;
    if mxdnop2 le 0 then mxdnop2 = .;
    if mxdnop le 0 then mxdnop = .;
    if mxdnoa5 le 0 then mxdnoa5 = .;
    if mxdnoa4 le 0 then mxdnoa4 = .;
    if mxdnoa3 le 0 then mxdnoa3 = .;
    if mxdnoa2 le 0 then mxdnoa2 = .;
    if mxdnoa le 0 then mxdnoa = .;
    if mxdnbp5 le 0 then mxdnbp5 = .;
    if mxdnbp4 le 0 then mxdnbp4 = .;
    if mxdnbp3 le 0 then mxdnbp3 = .;
    if mxdnbp2 le 0 then mxdnbp2 = .;
    if mxdnbp le 0 then mxdnbp = .;
    if mxdnba5 le 0 then mxdnba5 = .;
    if mxdnba4 le 0 then mxdnba4 = .;
    if mxdnba3 le 0 then mxdnba3 = .;
    if mxdnba2 le 0 then mxdnba2 = .;
    if mxdnba le 0 then mxdnba = .;
    if mnsao2rh le 0 then mnsao2rh = .;
    if mndrop5 le 0 then mndrop5 = .;
    if mndrop4 le 0 then mndrop4 = .;
    if mndrop3 le 0 then mndrop3 = .;
    if mndrop2 le 0 then mndrop2 = .;
    if mndrop le 0 then mndrop = .;
    if mndroa5 le 0 then mndroa5 = .;
    if mndroa4 le 0 then mndroa4 = .;
    if mndroa3 le 0 then mndroa3 = .;
    if mndroa2 le 0 then mndroa2 = .;
    if mndroa le 0 then mndroa = .;
    if mndrbp5 le 0 then mndrbp5 = .;
    if mndrbp4 le 0 then mndrbp4 = .;
    if mndrbp3 le 0 then mndrbp3 = .;
    if mndrbp2 le 0 then mndrbp2 = .;
    if mndrbp le 0 then mndrbp = .;
    if mndrba5 le 0 then mndrba5 = .;
    if mndrba4 le 0 then mndrba4 = .;
    if mndrba3 le 0 then mndrba3 = .;
    if mndrba2 le 0 then mndrba2 = .;
    if mndrba le 0 then mndrba = .;
    if mndnop5 le 0 then mndnop5 = .;
    if mndnop4 le 0 then mndnop4 = .;
    if mndnop3 le 0 then mndnop3 = .;
    if mndnop2 le 0 then mndnop2 = .;
    if mndnop le 0 then mndnop = .;
    if mndnoa5 le 0 then mndnoa5 = .;
    if mndnoa4 le 0 then mndnoa4 = .;
    if mndnoa3 le 0 then mndnoa3 = .;
    if mndnoa2 le 0 then mndnoa2 = .;
    if mndnoa le 0 then mndnoa = .;
    if mndnbp5 le 0 then mndnbp5 = .;
    if mndnbp4 le 0 then mndnbp4 = .;
    if mndnbp3 le 0 then mndnbp3 = .;
    if mndnbp2 le 0 then mndnbp2 = .;
    if mndnbp le 0 then mndnbp = .;
    if mndnba5 le 0 then mndnba5 = .;
    if mndnba4 le 0 then mndnba4 = .;
    if mndnba3 le 0 then mndnba3 = .;
    if mndnba2 le 0 then mndnba2 = .;
    if mndnba le 0 then mndnba = .;
    if avsao2rh le 0 then avsao2rh = .;
    if avdrop5 le 0 then avdrop5 = .;
    if avdrop4 le 0 then avdrop4 = .;
    if avdrop3 le 0 then avdrop3 = .;
    if avdrop2 le 0 then avdrop2 = .;
    if avdrop le 0 then avdrop = .;
    if avdroa5 le 0 then avdroa5 = .;
    if avdroa4 le 0 then avdroa4 = .;
    if avdroa3 le 0 then avdroa3 = .;
    if avdroa2 le 0 then avdroa2 = .;
    if avdroa le 0 then avdroa = .;
    if avdrbp5 le 0 then avdrbp5 = .;
    if avdrbp4 le 0 then avdrbp4 = .;
    if avdrbp3 le 0 then avdrbp3 = .;
    if avdrbp2 le 0 then avdrbp2 = .;
    if avdrbp le 0 then avdrbp = .;
    if avdrba5 le 0 then avdrba5 = .;
    if avdrba4 le 0 then avdrba4 = .;
    if avdrba3 le 0 then avdrba3 = .;
    if avdrba2 le 0 then avdrba2 = .;
    if avdrba le 0 then avdrba = .;
    if avdnop5 le 0 then avdnop5 = .;
    if avdnop4 le 0 then avdnop4 = .;
    if avdnop3 le 0 then avdnop3 = .;
    if avdnop2 le 0 then avdnop2 = .;
    if avdnop le 0 then avdnop = .;
    if avdnoa5 le 0 then avdnoa5 = .;
    if avdnoa4 le 0 then avdnoa4 = .;
    if avdnoa3 le 0 then avdnoa3 = .;
    if avdnoa2 le 0 then avdnoa2 = .;
    if avdnoa le 0 then avdnoa = .;
    if avdnbp5 le 0 then avdnbp5 = .;
    if avdnbp4 le 0 then avdnbp4 = .;
    if avdnbp3 le 0 then avdnbp3 = .;
    if avdnbp2 le 0 then avdnbp2 = .;
    if avdnbp le 0 then avdnbp = .;
    if avdnba5 le 0 then avdnba5 = .;
    if avdnba4 le 0 then avdnba4 = .;
    if avdnba3 le 0 then avdnba3 = .;
    if avdnba2 le 0 then avdnba2 = .;
    if avdnba le 0 then avdnba = .;
    if smxbroh le 0 then smxbroh = .;
    if smxbrbh le 0 then smxbrbh = .;
    if smxbnoh le 0 then smxbnoh = .;
    if smxbnbh le 0 then smxbnbh = .;
    if smnbroh le 0 then smnbroh = .;
    if smnbrbh le 0 then smnbrbh = .;
    if smnbnoh le 0 then smnbnoh = .;
    if smnbnbh le 0 then smnbnbh = .;
    if savbroh le 0 then savbroh = .;
    if savbrbh le 0 then savbrbh = .;
    if savbnoh le 0 then savbnoh = .;
    if savbnbh le 0 then savbnbh = .;
    if hmxbroh le 0 then hmxbroh = .;
    if hmxbrbh le 0 then hmxbrbh = .;
    if hmxbnoh le 0 then hmxbnoh = .;
    if hmxbnbh le 0 then hmxbnbh = .;
    if hmnbroh le 0 then hmnbroh = .;
    if hmnbrbh le 0 then hmnbrbh = .;
    if hmnbnoh le 0 then hmnbnoh = .;
    if hmnbnbh le 0 then hmnbnbh = .;
    if havbroh le 0 then havbroh = .;
    if havbrbh le 0 then havbrbh = .;
    if havbnoh le 0 then havbnoh = .;
    if havbnbh le 0 then havbnbh = .;
    if dmxbroh le 0 then dmxbroh = .;
    if dmxbrbh le 0 then dmxbrbh = .;
    if dmxbnoh le 0 then dmxbnoh = .;
    if dmxbnbh le 0 then dmxbnbh = .;
    if dmnbroh le 0 then dmnbroh = .;
    if dmnbrbh le 0 then dmnbrbh = .;
    if dmnbnoh le 0 then dmnbnoh = .;
    if dmnbnbh le 0 then dmnbnbh = .;
    if davbroh le 0 then davbroh = .;
    if davbrbh le 0 then davbrbh = .;
    if davbnoh le 0 then davbnoh = .;
    if davbnbh le 0 then davbnbh = .;
    if amxbroh le 0 then amxbroh = .;
    if amxbrbh le 0 then amxbrbh = .;
    if amxbnoh le 0 then amxbnoh = .;
    if amxbnbh le 0 then amxbnbh = .;
    if amnbroh le 0 then amnbroh = .;
    if amnbrbh le 0 then amnbrbh = .;
    if amnbnoh le 0 then amnbnoh = .;
    if amnbnbh le 0 then amnbnbh = .;
    if aavbroh le 0 then aavbroh = .;
    if aavbrbh le 0 then aavbrbh = .;
    if aavbnoh le 0 then aavbnoh = .;
    if aavbnbh le 0 then aavbnbh = .;
    if mxhrop5 le 0 then mxhrop5 = .;
    if mxhrop4 le 0 then mxhrop4 = .;
    if mxhrop3 le 0 then mxhrop3 = .;
    if mxhrop2 le 0 then mxhrop2 = .;
    if mxhrop le 0 then mxhrop = .;
    if mxhroa5 le 0 then mxhroa5 = .;
    if mxhroa4 le 0 then mxhroa4 = .;
    if mxhroa3 le 0 then mxhroa3 = .;
    if mxhroa2 le 0 then mxhroa2 = .;
    if mxhroa le 0 then mxhroa = .;
    if mxhrbp5 le 0 then mxhrbp5 = .;
    if mxhrbp4 le 0 then mxhrbp4 = .;
    if mxhrbp3 le 0 then mxhrbp3 = .;
    if mxhrbp2 le 0 then mxhrbp2 = .;
    if mxhrbp le 0 then mxhrbp = .;
    if mxhrba5 le 0 then mxhrba5 = .;
    if mxhrba4 le 0 then mxhrba4 = .;
    if mxhrba3 le 0 then mxhrba3 = .;
    if mxhrba2 le 0 then mxhrba2 = .;
    if mxhrba le 0 then mxhrba = .;
    if mxhnop5 le 0 then mxhnop5 = .;
    if mxhnop4 le 0 then mxhnop4 = .;
    if mxhnop3 le 0 then mxhnop3 = .;
    if mxhnop2 le 0 then mxhnop2 = .;
    if mxhnop le 0 then mxhnop = .;
    if mxhnoa5 le 0 then mxhnoa5 = .;
    if mxhnoa4 le 0 then mxhnoa4 = .;
    if mxhnoa3 le 0 then mxhnoa3 = .;
    if mxhnoa2 le 0 then mxhnoa2 = .;
    if mxhnoa le 0 then mxhnoa = .;
    if mxhnbp5 le 0 then mxhnbp5 = .;
    if mxhnbp4 le 0 then mxhnbp4 = .;
    if mxhnbp3 le 0 then mxhnbp3 = .;
    if mxhnbp2 le 0 then mxhnbp2 = .;
    if mxhnbp le 0 then mxhnbp = .;
    if mxhnba5 le 0 then mxhnba5 = .;
    if mxhnba4 le 0 then mxhnba4 = .;
    if mxhnba3 le 0 then mxhnba3 = .;
    if mxhnba2 le 0 then mxhnba2 = .;
    if mxhnba le 0 then mxhnba = .;
    if mnhrop5 le 0 then mnhrop5 = .;
    if mnhrop4 le 0 then mnhrop4 = .;
    if mnhrop3 le 0 then mnhrop3 = .;
    if mnhrop2 le 0 then mnhrop2 = .;
    if mnhrop le 0 then mnhrop = .;
    if mnhroa5 le 0 then mnhroa5 = .;
    if mnhroa4 le 0 then mnhroa4 = .;
    if mnhroa3 le 0 then mnhroa3 = .;
    if mnhroa2 le 0 then mnhroa2 = .;
    if mnhroa le 0 then mnhroa = .;
    if mnhrbp5 le 0 then mnhrbp5 = .;
    if mnhrbp4 le 0 then mnhrbp4 = .;
    if mnhrbp3 le 0 then mnhrbp3 = .;
    if mnhrbp2 le 0 then mnhrbp2 = .;
    if mnhrbp le 0 then mnhrbp = .;
    if mnhrba5 le 0 then mnhrba5 = .;
    if mnhrba4 le 0 then mnhrba4 = .;
    if mnhrba3 le 0 then mnhrba3 = .;
    if mnhrba2 le 0 then mnhrba2 = .;
    if mnhrba le 0 then mnhrba = .;
    if mnhnop3 le 0 then mnhnop3 = .;
    if mnhnop2 le 0 then mnhnop2 = .;
    if mnhnop le 0 then mnhnop = .;
    if mnhnoa5 le 0 then mnhnoa5 = .;
    if mnhnoa4 le 0 then mnhnoa4 = .;
    if mnhnoa3 le 0 then mnhnoa3 = .;
    if mnhnoa2 le 0 then mnhnoa2 = .;
    if mnhnoa le 0 then mnhnoa = .;
    if mnhnbp5 le 0 then mnhnbp5 = .;
    if mnhnbp4 le 0 then mnhnbp4 = .;
    if mnhnbp3 le 0 then mnhnbp3 = .;
    if mnhnbp2 le 0 then mnhnbp2 = .;
    if mnhnbp le 0 then mnhnbp = .;
    if mnhnba5 le 0 then mnhnba5 = .;
    if mnhnba4 le 0 then mnhnba4 = .;
    if mnhnba3 le 0 then mnhnba3 = .;
    if mnhnba2 le 0 then mnhnba2 = .;
    if mnhnba le 0 then mnhnba = .;
    if avhrop5 le 0 then avhrop5 = .;
    if avhrop4 le 0 then avhrop4 = .;
    if avhrop3 le 0 then avhrop3 = .;
    if avhrop2 le 0 then avhrop2 = .;
    if avhrop le 0 then avhrop = .;
    if avhroa5 le 0 then avhroa5 = .;
    if avhroa4 le 0 then avhroa4 = .;
    if avhroa3 le 0 then avhroa3 = .;
    if avhroa2 le 0 then avhroa2 = .;
    if avhroa le 0 then avhroa = .;
    if avhrbp5 le 0 then avhrbp5 = .;
    if avhrbp4 le 0 then avhrbp4 = .;
    if avhrbp3 le 0 then avhrbp3 = .;
    if avhrbp2 le 0 then avhrbp2 = .;
    if avhrbp le 0 then avhrbp = .;
    if avhrba5 le 0 then avhrba5 = .;
    if avhrba4 le 0 then avhrba4 = .;
    if avhrba3 le 0 then avhrba3 = .;
    if avhrba2 le 0 then avhrba2 = .;
    if avhrba le 0 then avhrba = .;
    if avhnop5 le 0 then avhnop5 = .;
    if avhnop4 le 0 then avhnop4 = .;
    if avhnop3 le 0 then avhnop3 = .;
    if avhnop2 le 0 then avhnop2 = .;
    if avhnop le 0 then avhnop = .;
    if avhnoa5 le 0 then avhnoa5 = .;
    if avhnoa4 le 0 then avhnoa4 = .;
    if avhnoa3 le 0 then avhnoa3 = .;
    if avhnoa2 le 0 then avhnoa2 = .;
    if avhnoa le 0 then avhnoa = .;
    if avhnbp5 le 0 then avhnbp5 = .;
    if avhnbp4 le 0 then avhnbp4 = .;
    if avhnbp3 le 0 then avhnbp3 = .;
    if avhnbp2 le 0 then avhnbp2 = .;
    if avhnbp le 0 then avhnbp = .;
    if avhnba5 le 0 then avhnba5 = .;
    if avhnba4 le 0 then avhnba4 = .;
    if avhnba3 le 0 then avhnba3 = .;
    if avhnba2 le 0 then avhnba2 = .;
    if avhnba le 0 then avhnba = .;
    if mxoarop5 le 0 then mxoarop5 = .;
    if mxoarop4 le 0 then mxoarop4 = .;
    if mxoarop3 le 0 then mxoarop3 = .;
    if mxoarop2 le 0 then mxoarop2 = .;
    if mxoarop le 0 then mxoarop = .;
    if mxoaroa5 le 0 then mxoaroa5 = .;
    if mxoaroa4 le 0 then mxoaroa4 = .;
    if mxoaroa3 le 0 then mxoaroa3 = .;
    if mxoaroa2 le 0 then mxoaroa2 = .;
    if mxoaroa le 0 then mxoaroa = .;
    if mxoarbp5 le 0 then mxoarbp5 = .;
    if mxoarbp4 le 0 then mxoarbp4 = .;
    if mxoarbp3 le 0 then mxoarbp3 = .;
    if mxoarbp2 le 0 then mxoarbp2 = .;
    if mxoarbp le 0 then mxoarbp = .;
    if mxoarba5 le 0 then mxoarba5 = .;
    if mxoarba4 le 0 then mxoarba4 = .;
    if mxoarba3 le 0 then mxoarba3 = .;
    if mxoarba2 le 0 then mxoarba2 = .;
    if mxoarba le 0 then mxoarba = .;
    if mxoanop5 le 0 then mxoanop5 = .;
    if mxoanop4 le 0 then mxoanop4 = .;
    if mxoanop3 le 0 then mxoanop3 = .;
    if mxoanop2 le 0 then mxoanop2 = .;
    if mxoanop le 0 then mxoanop = .;
    if mxoanoa5 le 0 then mxoanoa5 = .;
    if mxoanoa4 le 0 then mxoanoa4 = .;
    if mxoanoa3 le 0 then mxoanoa3 = .;
    if mxoanoa2 le 0 then mxoanoa2 = .;
    if mxoanoa le 0 then mxoanoa = .;
    if mxoanbp5 le 0 then mxoanbp5 = .;
    if mxoanbp4 le 0 then mxoanbp4 = .;
    if mxoanbp3 le 0 then mxoanbp3 = .;
    if mxoanbp2 le 0 then mxoanbp2 = .;
    if mxoanbp le 0 then mxoanbp = .;
    if mxoanba5 le 0 then mxoanba5 = .;
    if mxoanba4 le 0 then mxoanba4 = .;
    if mxoanba3 le 0 then mxoanba3 = .;
    if mxoanba2 le 0 then mxoanba2 = .;
    if mxoanba le 0 then mxoanba = .;
    if mnoarop5 le 0 then mnoarop5 = .;
    if mnoarop4 le 0 then mnoarop4 = .;
    if mnoarop3 le 0 then mnoarop3 = .;
    if mnoarop2 le 0 then mnoarop2 = .;
    if mnoarop le 0 then mnoarop = .;
    if mnoaroa5 le 0 then mnoaroa5 = .;
    if mnoaroa4 le 0 then mnoaroa4 = .;
    if mnoaroa3 le 0 then mnoaroa3 = .;
    if mnoaroa2 le 0 then mnoaroa2 = .;
    if mnoaroa le 0 then mnoaroa = .;
    if mnoarbp5 le 0 then mnoarbp5 = .;
    if mnoarbp4 le 0 then mnoarbp4 = .;
    if mnoarbp3 le 0 then mnoarbp3 = .;
    if mnoarbp2 le 0 then mnoarbp2 = .;
    if mnoarbp le 0 then mnoarbp = .;
    if mnoarba5 le 0 then mnoarba5 = .;
    if mnoarba4 le 0 then mnoarba4 = .;
    if mnoarba3 le 0 then mnoarba3 = .;
    if mnoarba2 le 0 then mnoarba2 = .;
    if mnoarba le 0 then mnoarba = .;
    if mnoanop5 le 0 then mnoanop5 = .;
    if mnoanop4 le 0 then mnoanop4 = .;
    if mnoanop3 le 0 then mnoanop3 = .;
    if mnoanop2 le 0 then mnoanop2 = .;
    if mnoanop le 0 then mnoanop = .;
    if mnoanoa5 le 0 then mnoanoa5 = .;
    if mnoanoa4 le 0 then mnoanoa4 = .;
    if mnoanoa3 le 0 then mnoanoa3 = .;
    if mnoanoa2 le 0 then mnoanoa2 = .;
    if mnoanoa le 0 then mnoanoa = .;
    if mnoanbp5 le 0 then mnoanbp5 = .;
    if mnoanbp4 le 0 then mnoanbp4 = .;
    if mnoanbp3 le 0 then mnoanbp3 = .;
    if mnoanbp2 le 0 then mnoanbp2 = .;
    if mnoanbp le 0 then mnoanbp = .;
    if mnoanba5 le 0 then mnoanba5 = .;
    if mnoanba4 le 0 then mnoanba4 = .;
    if mnoanba3 le 0 then mnoanba3 = .;
    if mnoanba2 le 0 then mnoanba2 = .;
    if mnoanba le 0 then mnoanba = .;
    if avoarop5 le 0 then avoarop5 = .;
    if avoarop4 le 0 then avoarop4 = .;
    if avoarop3 le 0 then avoarop3 = .;
    if avoarop2 le 0 then avoarop2 = .;
    if avoarop le 0 then avoarop = .;
    if avoaroa5 le 0 then avoaroa5 = .;
    if avoaroa4 le 0 then avoaroa4 = .;
    if avoaroa3 le 0 then avoaroa3 = .;
    if avoaroa2 le 0 then avoaroa2 = .;
    if avoaroa le 0 then avoaroa = .;
    if avoarbp5 le 0 then avoarbp5 = .;
    if avoarbp4 le 0 then avoarbp4 = .;
    if avoarbp3 le 0 then avoarbp3 = .;
    if avoarbp2 le 0 then avoarbp2 = .;
    if avoarbp le 0 then avoarbp = .;
    if avoarba5 le 0 then avoarba5 = .;
    if avoarba4 le 0 then avoarba4 = .;
    if avoarba3 le 0 then avoarba3 = .;
    if avoarba2 le 0 then avoarba2 = .;
    if avoarba le 0 then avoarba = .;
    if avoanop5 le 0 then avoanop5 = .;
    if avoanop4 le 0 then avoanop4 = .;
    if avoanop3 le 0 then avoanop3 = .;
    if avoanop2 le 0 then avoanop2 = .;
    if avoanop le 0 then avoanop = .;
    if avoanoa5 le 0 then avoanoa5 = .;
    if avoanoa4 le 0 then avoanoa4 = .;
    if avoanoa3 le 0 then avoanoa3 = .;
    if avoanoa2 le 0 then avoanoa2 = .;
    if avoanoa le 0 then avoanoa = .;
    if avoanbp5 le 0 then avoanbp5 = .;
    if avoanbp4 le 0 then avoanbp4 = .;
    if avoanbp3 le 0 then avoanbp3 = .;
    if avoanbp2 le 0 then avoanbp2 = .;
    if avoanbp le 0 then avoanbp = .;
    if avoanba5 le 0 then avoanba5 = .;
    if avoanba4 le 0 then avoanba4 = .;
    if avoanba3 le 0 then avoanba3 = .;
    if avoanba2 le 0 then avoanba2 = .;
    if avoanba le 0 then avoanba = .;
    if mxcarop5 le 0 then mxcarop5 = .;
    if mxcarop4 le 0 then mxcarop4 = .;
    if mxcarop3 le 0 then mxcarop3 = .;
    if mxcarop2 le 0 then mxcarop2 = .;
    if mxcarop le 0 then mxcarop = .;
    if mxcaroa5 le 0 then mxcaroa5 = .;
    if mxcaroa4 le 0 then mxcaroa4 = .;
    if mxcaroa3 le 0 then mxcaroa3 = .;
    if mxcaroa2 le 0 then mxcaroa2 = .;
    if mxcaroa le 0 then mxcaroa = .;
    if mxcarbp5 le 0 then mxcarbp5 = .;
    if mxcarbp4 le 0 then mxcarbp4 = .;
    if mxcarbp3 le 0 then mxcarbp3 = .;
    if mxcarbp2 le 0 then mxcarbp2 = .;
    if mxcarbp le 0 then mxcarbp = .;
    if mxcarba5 le 0 then mxcarba5 = .;
    if mxcarba4 le 0 then mxcarba4 = .;
    if mxcarba3 le 0 then mxcarba3 = .;
    if mxcarba2 le 0 then mxcarba2 = .;
    if mxcarba le 0 then mxcarba = .;
    if mxcanop5 le 0 then mxcanop5 = .;
    if mxcanop4 le 0 then mxcanop4 = .;
    if mxcanop3 le 0 then mxcanop3 = .;
    if mxcanop2 le 0 then mxcanop2 = .;
    if mxcanop le 0 then mxcanop = .;
    if mxcanoa5 le 0 then mxcanoa5 = .;
    if mxcanoa4 le 0 then mxcanoa4 = .;
    if mxcanoa3 le 0 then mxcanoa3 = .;
    if mxcanoa2 le 0 then mxcanoa2 = .;
    if mxcanoa le 0 then mxcanoa = .;
    if mxcanbp5 le 0 then mxcanbp5 = .;
    if mxcanbp4 le 0 then mxcanbp4 = .;
    if mxcanbp3 le 0 then mxcanbp3 = .;
    if mxcanbp2 le 0 then mxcanbp2 = .;
    if mxcanbp le 0 then mxcanbp = .;
    if mxcanba5 le 0 then mxcanba5 = .;
    if mxcanba4 le 0 then mxcanba4 = .;
    if mxcanba3 le 0 then mxcanba3 = .;
    if mxcanba2 le 0 then mxcanba2 = .;
    if mxcanba le 0 then mxcanba = .;
    if mncarop5 le 0 then mncarop5 = .;
    if mncarop4 le 0 then mncarop4 = .;
    if mncarop3 le 0 then mncarop3 = .;
    if mncarop2 le 0 then mncarop2 = .;
    if mncarop le 0 then mncarop = .;
    if mncaroa5 le 0 then mncaroa5 = .;
    if mncaroa4 le 0 then mncaroa4 = .;
    if mncaroa3 le 0 then mncaroa3 = .;
    if mncaroa2 le 0 then mncaroa2 = .;
    if mncaroa le 0 then mncaroa = .;
    if mncarbp5 le 0 then mncarbp5 = .;
    if mncarbp4 le 0 then mncarbp4 = .;
    if mncarbp3 le 0 then mncarbp3 = .;
    if mncarbp2 le 0 then mncarbp2 = .;
    if mncarbp le 0 then mncarbp = .;
    if mncarba5 le 0 then mncarba5 = .;
    if mncarba4 le 0 then mncarba4 = .;
    if mncarba3 le 0 then mncarba3 = .;
    if mncarba2 le 0 then mncarba2 = .;
    if mncarba le 0 then mncarba = .;
    if mncanop5 le 0 then mncanop5 = .;
    if mncanop4 le 0 then mncanop4 = .;
    if mncanop3 le 0 then mncanop3 = .;
    if mncanop2 le 0 then mncanop2 = .;
    if mncanop le 0 then mncanop = .;
    if mncanoa5 le 0 then mncanoa5 = .;
    if mncanoa4 le 0 then mncanoa4 = .;
    if mncanoa3 le 0 then mncanoa3 = .;
    if mncanoa2 le 0 then mncanoa2 = .;
    if mncanoa le 0 then mncanoa = .;
    if mncanbp5 le 0 then mncanbp5 = .;
    if mncanbp4 le 0 then mncanbp4 = .;
    if mncanbp3 le 0 then mncanbp3 = .;
    if mncanbp2 le 0 then mncanbp2 = .;
    if mncanbp le 0 then mncanbp = .;
    if mncanba5 le 0 then mncanba5 = .;
    if mncanba4 le 0 then mncanba4 = .;
    if mncanba3 le 0 then mncanba3 = .;
    if mncanba2 le 0 then mncanba2 = .;
    if mncanba le 0 then mncanba = .;
    if avcarop5 le 0 then avcarop5 = .;
    if avcarop4 le 0 then avcarop4 = .;
    if avcarop3 le 0 then avcarop3 = .;
    if avcarop2 le 0 then avcarop2 = .;
    if avcarop le 0 then avcarop = .;
    if avcaroa5 le 0 then avcaroa5 = .;
    if avcaroa4 le 0 then avcaroa4 = .;
    if avcaroa3 le 0 then avcaroa3 = .;
    if avcaroa2 le 0 then avcaroa2 = .;
    if avcaroa le 0 then avcaroa = .;
    if avcarbp5 le 0 then avcarbp5 = .;
    if avcarbp4 le 0 then avcarbp4 = .;
    if avcarbp3 le 0 then avcarbp3 = .;
    if avcarbp2 le 0 then avcarbp2 = .;
    if avcarbp le 0 then avcarbp = .;
    if avcarba5 le 0 then avcarba5 = .;
    if avcarba4 le 0 then avcarba4 = .;
    if avcarba3 le 0 then avcarba3 = .;
    if avcarba2 le 0 then avcarba2 = .;
    if avcarba le 0 then avcarba = .;
    if avcanop5 le 0 then avcanop5 = .;
    if avcanop4 le 0 then avcanop4 = .;
    if avcanop3 le 0 then avcanop3 = .;
    if avcanop2 le 0 then avcanop2 = .;
    if avcanop le 0 then avcanop = .;
    if avcanoa5 le 0 then avcanoa5 = .;
    if avcanoa4 le 0 then avcanoa4 = .;
    if avcanoa3 le 0 then avcanoa3 = .;
    if avcanoa2 le 0 then avcanoa2 = .;
    if avcanoa le 0 then avcanoa = .;
    if avcanbp5 le 0 then avcanbp5 = .;
    if avcanbp4 le 0 then avcanbp4 = .;
    if avcanbp3 le 0 then avcanbp3 = .;
    if avcanbp2 le 0 then avcanbp2 = .;
    if avcanbp le 0 then avcanbp = .;
    if avcanba5 le 0 then avcanba5 = .;
    if avcanba4 le 0 then avcanba4 = .;
    if avcanba3 le 0 then avcanba3 = .;
    if avcanba2 le 0 then avcanba2 = .;
    if avcanba le 0 then avcanba = .;
    if mnsao2nh le 0 then mnsao2nh = .;
    if pm202 > 300 then pm202 = pm202/10;
    if pm207 > 300 then pm207 = pm207/10;
    if pm220a2 le 0 then pm220a2 = .;
    if pm220b2 le 0 then pm220b2 = .;
    if pm220c2 le 0 then pm220c2 = .;
    if mh_s2 le 0 then mh_s2 = .;
    if re_s2 le 0 then re_s2 = .;
    if sf_s2 le 0 then sf_s2 = .;
    if gh_s2 le 0 then gh_s2 = .;
    if bp_s2 le 0 then bp_s2 = .;
    if pf_s2 le 0 then pf_s2 = .;
    if vt_s2 le 0 then vt_s2 = .;
    if hi215 le 0 then hi215 = .;
    if mndnba5 = 255 then mndnba5 = .;
    if mndnba4 = 255 then mndnba4 = .;
    if mndnba3 = 255 then mndnba3 = .;
    if mndnba2 = 255 then mndnba2 = .;
    if mndnba = 255 then mndnba = .;
    if mndnoa5 = 255 then mndnoa5 = .;
    if mndnoa4 = 255 then mndnoa4 = .;
    if mndnoa3 = 255 then mndnoa3 = .;
    if mndnoa2 = 255 then mndnoa2 = .;
    if mndnoa = 255 then mndnoa = .;
    if mndrba5 = 255 then mndrba5 = .;
    if mndrba4 = 255 then mndrba4 = .;
    if mndrba3 = 255 then mndrba3 = .;
    if mndrba = 255 then mndrba = .;
    if mndroa5 = 255 then mndroa5 = .;
    if mndroa4 = 255 then mndroa4 = .;
    if mndroa = 255 then mndroa = .;
    if mndnbp = 255 then mndnbp = .;
    pm212a = pm212a/10;
    pm212b = pm212b/10;
    pm212c = pm212c/10;

    visitnumber = 2;

    if permiss = 1;

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
    ahi_o0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_o0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;

    ahi_c0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                    carbp + carop + canbp + canop ) / slpprdp;

    cent_obs_ratio = (carbp + carop + canbp + canop) /
                      (oarbp + oarop + oanbp + oanop);
    cent_obs_ratioa = (carba + caroa + canba + canoa) /
                      (oarba + oaroa + oanba + oanoa);

    drop
      repsgpptid
      responqa
      permiss
      /* removed duplicate variables for 0.16.0 */
      oahi
      pctlt75
      pctlt80
      pctlt85
      pctlt90
      slp_eff
      slp_lat
      slp_rdi
      slp_time
      time_bed
      tmremp
      tmstg34p
      tmstg1p
      tmstg2p
      slptime
      minremp
      minstg1p
      minstg2p
      mnstg34p
      rem_lat1
      losao2nr
      losao2r
      sao2nrem
      sao2rem
      /* end set of removed vairables for 0.16.0 */
      medalert /* extraneous, other alert variables exist */
      ;
  run;

  proc sort data=shhs2;
    by nsrrid;
  run;

  proc sort data=s2_psgqual;
    by nsrrid;
  run;

  data shhs2;
    merge shhs2(in=a) s2_psgqual;
    by nsrrid;

    if a;
  run;

  data shhs2;
    merge shhs2(in=a) shhs_demo(in=b);
    by nsrrid;

    if a and b;

      if age_s2 > 89 then age_s2 = 90;

    drop permiss;
  run;

  proc import datafile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\start-date-of-recording\nsrr-shhs2-edf-start-date-of-recording-month.csv"
    out=shhs2_psgmonth_in
    dbms=csv
    replace;
  run;

  data shhs2_psgmonth;
    set shhs2_psgmonth_in;

    keep
      nsrrid
      psg_month
      ;
  run;

  data shhs2;
    merge shhs2 shhs2_psgmonth;
    by nsrrid;
  run;

  proc import datafile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\unit-headbox-ids\shhs2-monitor-headbox.csv"
    out=shhs2_monitor_in
    dbms=csv
    replace;
  run;

  data shhs2_monitor;
    set shhs2_monitor_in;

    keep
      nsrrid
      monitor_id
      headbox_id
      ;
  run;

  data shhs2;
    merge shhs2 shhs2_monitor;
    by nsrrid;
  run;

  data shhs_cvd_event;
    length nsrrid 8.;
    merge shhs_cvd_event(in=a) obfid;
    by pptid;

    if a;
    visitnumber = 3;

    if permiss = 1;

    drop pptid blpsgdate permiss;
  run;

  proc sort data=shhs_cvd_event;
    by nsrrid;
  run;

  proc sort data=shhs_demo;
    by nsrrid;
  run;

  data shhs_cvd_event;
    merge shhs_cvd_event(in=a) shhs_demo(in=b);
    by nsrrid;

    if a and b;
  run;

  data shhs_cvd_summary;
    length nsrrid 8.;
    merge shhs_cvd_summary(in=a) obfid;
    by pptid;

    if a;
    visitnumber = 3;

    if permiss = 1;

    drop
      omni blpsgdate permiss stent_date /* stent_date is removed because there is no data */
      ca15 cabg15 stroke15 mi15 /* baseline prevalent conditions exist in shhs1 and do not need to be duplicated */
      ;
  run;

  proc sort data=shhs_cvd_summary;
    by nsrrid;
  run;

  data shhs_cvd_summary;
    merge shhs_cvd_summary(in=a) shhs_afib_nsrrid (in=b) shhs_demo(in=c);
    by nsrrid;

    if a and b and c;
  run;

*******************************************************************************;
* create eeg dataset ;
*******************************************************************************;
  	proc import datafile="\\rfawin.partners.org\bwh-sleepepi-shhs\nsrr-prep\eeg-biomarkers-younes\_source\EEG_Biomarkers_SHHS1_v4.xlsx"
	        out=eeg
	        dbms=xlsx
	        replace;
	run;

	  data shhs_eeg;
	set eeg;

	format visitnumber $8.;
	visitnumber = 1;

	rename file_id = nsrrid;
	rename bmi = bmi_s1;
	rename age = age_s1;
	run;





*******************************************************************************;
* create harmonized datasets ;
*******************************************************************************;
*create harmonized data for visit 1;
data shhs1_harmonized;
  set shhs1;
  *create visitnumber variable for Spout to use for graph generation;
    visitnumber = 1;

*demographics
*age;
*use age_s1;
  format nsrr_age 8.2;
  if age_s1 gt 89 then nsrr_age = 90;
  else if age_s1 le 89 then nsrr_age = age_s1;

*age_gt89;
*use age_s1;
  format nsrr_age_gt89 $10.; 
  if age_s1 gt 89 then nsrr_age_gt89='yes';
  else if age_s1 le 89 then nsrr_age_gt89='no';

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

*anthropometry
*bmi;
*use bmi_s1;
  format nsrr_bmi 10.9;
  nsrr_bmi = bmi_s1;

*clinical data/vital signs
*bp_systolic;
*use systbp;
  format nsrr_bp_systolic 8.2;
  nsrr_bp_systolic = systbp;

*bp_diastolic;
*use diasbp;
  format nsrr_bp_diastolic 8.2;
  nsrr_bp_diastolic = diasbp;

*lifestyle and behavioral health
*current_smoker;
*use smokstat_s1;
  format nsrr_current_smoker $100.;
  if smokstat_s1 = 0 then nsrr_current_smoker = 'no';
  else if smokstat_s1 = 01 then nsrr_current_smoker = 'yes';
  else if smokstat_s1 = 02 then nsrr_current_smoker = 'no';
  else if smokstat_s1 = . then nsrr_current_smoker = 'not reported';


*ever_smoker;
*use smokstat_s1; 
  format nsrr_ever_smoker $100.;
  if smokstat_s1 = 00 then nsrr_ever_smoker = 'no';
  else if smokstat_s1 ge 01 then nsrr_ever_smoker = 'yes';
  else if smokerstat_s1 = 2 then nsrr_ever_smoker = 'yes';
  else if smokstat_s1 = . then nsrr_ever_smoker = 'not reported';

*polysomnography;
*nsrr_ahi_hp3u;
*use ahi_a0h3;
  format nsrr_ahi_hp3u 8.2;
  nsrr_ahi_hp3u = ahi_a0h3;

*nsrr_ahi_hp3r_aasm15;
*use ahi_a0h3a;
  format nsrr_ahi_hp3r_aasm15 8.2;
  nsrr_ahi_hp3r_aasm15 = ahi_a0h3a;
 
*nsrr_ahi_hp4u_aasm15;
*use ahi_a0h4;
  format nsrr_ahi_hp4u_aasm15 8.2;
  nsrr_ahi_hp4u_aasm15 = ahi_a0h4;
  
*nsrr_ahi_hp4r;
*use ahi_a0h4a;
  format nsrr_ahi_hp4r 8.2;
  nsrr_ahi_hp4r = ahi_a0h4a;
 
*nsrr_ttldursp_f1;
*use slpprdp;
  format nsrr_ttldursp_f1 8.2;
  nsrr_ttldursp_f1 = slpprdp;
  
*nsrr_phrnumar_f1;
*use ai_all;
  format nsrr_phrnumar_f1 8.2;
  nsrr_phrnumar_f1 = ai_all;  

*nsrr_flag_spsw;
*use staging5;
  format nsrr_flag_spsw $100.;
    if staging5 = 1 then nsrr_flag_spsw = 'sleep/wake only';
    else if staging5 = 0 then nsrr_flag_spsw = 'full scoring';
  else if staging5 = . then nsrr_flag_spsw = 'unknown';  

*nsrr_ttleffsp_f1;
*use slpeffp;
  format nsrr_ttleffsp_f1 8.2;
  nsrr_ttleffsp_f1 = slpeffp;  

*nsrr_ttllatsp_f1;
*use slplatp;
  format nsrr_ttllatsp_f1 8.2;
  nsrr_ttllatsp_f1 = slplatp; 

*nsrr_ttlprdsp_s1sr;
*use remlaip;
  format nsrr_ttlprdsp_s1sr 8.2;
  nsrr_ttlprdsp_s1sr = remlaip; 

*nsrr_ttldursp_s1sr;
*use remlaiip;
  format nsrr_ttldursp_s1sr 8.2;
  nsrr_ttldursp_s1sr = remlaiip; 

*nsrr_ttldurws_f1;
*use waso;
  format nsrr_ttldurws_f1 8.2;
  nsrr_ttldurws_f1 = waso;
  
*nsrr_pctdursp_s1;
*use timest1p;
  format nsrr_pctdursp_s1 8.2;
  nsrr_pctdursp_s1 = timest1p;

*nsrr_pctdursp_s2;
*use timest2p;
  format nsrr_pctdursp_s2 8.2;
  nsrr_pctdursp_s2 = timest2p;

*nsrr_pctdursp_s3;
*use times34p;
  format nsrr_pctdursp_s3 8.2;
  nsrr_pctdursp_s3 = times34p;

*nsrr_pctdursp_sr;
*use timeremp;
  format nsrr_pctdursp_sr 8.2;
  nsrr_pctdursp_sr = timeremp;

*nsrr_ttlprdbd_f1;
*use timebedp;
  format nsrr_ttlprdbd_f1 8.2;
  nsrr_ttlprdbd_f1 = timebedp;  
  
  keep 
    nsrrid
    visitnumber
    nsrr_age
    nsrr_age_gt89
    nsrr_sex
    nsrr_race
    nsrr_ethnicity
    nsrr_bmi
    nsrr_bp_systolic
    nsrr_bp_diastolic
    nsrr_current_smoker
    nsrr_ever_smoker
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_ttldursp_f1
    nsrr_phrnumar_f1
    nsrr_flag_spsw
  	nsrr_ttleffsp_f1
	nsrr_ttllatsp_f1
	nsrr_ttlprdsp_s1sr
	nsrr_ttldursp_s1sr
	nsrr_ttldurws_f1
	nsrr_pctdursp_s1
	nsrr_pctdursp_s2
	nsrr_pctdursp_s3
	nsrr_pctdursp_sr
	nsrr_ttlprdbd_f1
    ;
run;

*create harmonized data for visit 2;
data shhs2_harmonized;
  set shhs2;
  *create visitnumber variable for Spout to use for graph generation;
    visitnumber = 2;

*demographics
*age;
*use age_s2;
  format nsrr_age 8.2;
  if age_s2 gt 89 then nsrr_age = 90;
  else if age_s2 le 89 then nsrr_age = age_s2;

*age_gt89;
*use age_s2;
  format nsrr_age_gt89 $10.; 
  if age_s2 gt 89 then nsrr_age_gt89='yes';
  else if age_s2 le 89 then nsrr_age_gt89='no';

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

*anthropometry
*bmi;
*use bmi_s2;
  format nsrr_bmi 10.9;
  nsrr_bmi = bmi_s2;

*clinical data/vital signs
*bp_systolic;
*use systbp;
  format nsrr_bp_systolic 8.2;
  nsrr_bp_systolic = systbp;

*bp_diastolic;
*use diasbp;
  format nsrr_bp_diastolic 8.2;
  nsrr_bp_diastolic = diasbp;

*lifestyle and behavioral health
*current_smoker;
*use smokstat_s2;
  format nsrr_current_smoker $100.;
  if smokstat_s2 = 0 then nsrr_current_smoker = 'no';
  else if smokstat_s2 = 01 then nsrr_current_smoker = 'yes';
  else if smokstat_s2 = 02 then nsrr_current_smoker = 'no';
  else if smokstat_s2 = . then nsrr_current_smoker = 'not reported';


*ever_smoker;
*use smokstat_s2; 
  format nsrr_ever_smoker $100.;
  if smokstat_s2 = 00 then nsrr_ever_smoker = 'no';
  else if smokstat_s2 ge 01 then nsrr_ever_smoker = 'yes';
  else if smokerstat_s2 = 2 then nsrr_ever_smoker = 'yes';
  else if smokstat_s2 = . then nsrr_ever_smoker = 'not reported';

*polysomnography;
*nsrr_ahi_hp3u;
*use ahi_a0h3;
  format nsrr_ahi_hp3u 8.2;
  nsrr_ahi_hp3u = ahi_a0h3;

*nsrr_ahi_hp3r_aasm15;
*use ahi_a0h3a;
  format nsrr_ahi_hp3r_aasm15 8.2;
  nsrr_ahi_hp3r_aasm15 = ahi_a0h3a;
 
*nsrr_ahi_hp4u_aasm15;
*use ahi_a0h4;
  format nsrr_ahi_hp4u_aasm15 8.2;
  nsrr_ahi_hp4u_aasm15 = ahi_a0h4;
  
*nsrr_ahi_hp4r;
*use ahi_a0h4a;
  format nsrr_ahi_hp4r 8.2;
  nsrr_ahi_hp4r = ahi_a0h4a;
 
*nsrr_ttldursp_f1;
*use slpprdp;
  format nsrr_ttldursp_f1 8.2;
  nsrr_ttldursp_f1 = slpprdp;
  
*nsrr_phrnumar_f1;
*use ai_all;
  format nsrr_phrnumar_f1 8.2;
  nsrr_phrnumar_f1 = ai_all;  

*nsrr_flag_spsw;
*use staging5;
  format nsrr_flag_spsw $100.;
    if staging5 = 1 then nsrr_flag_spsw = 'sleep/wake only';
    else if staging5 = 0 then nsrr_flag_spsw = 'full scoring';
  else if staging5 = . then nsrr_flag_spsw = 'unknown';  

*nsrr_ttleffsp_f1;
*use slpeffp;
  format nsrr_ttleffsp_f1 8.2;
  nsrr_ttleffsp_f1 = slpeffp;  

*nsrr_ttllatsp_f1;
*use slplatp;
  format nsrr_ttllatsp_f1 8.2;
  nsrr_ttllatsp_f1 = slplatp; 

*nsrr_ttlprdsp_s1sr;
*use remlaip;
  format nsrr_ttlprdsp_s1sr 8.2;
  nsrr_ttlprdsp_s1sr = remlaip; 

*nsrr_ttldursp_s1sr;
*use remlaiip;
  format nsrr_ttldursp_s1sr 8.2;
  nsrr_ttldursp_s1sr = remlaiip; 

*nsrr_ttldurws_f1;
*use waso;
  format nsrr_ttldurws_f1 8.2;
  nsrr_ttldurws_f1 = waso;
  
*nsrr_pctdursp_s1;
*use timest1p;
  format nsrr_pctdursp_s1 8.2;
  nsrr_pctdursp_s1 = timest1p;

*nsrr_pctdursp_s2;
*use timest2p;
  format nsrr_pctdursp_s2 8.2;
  nsrr_pctdursp_s2 = timest2p;

*nsrr_pctdursp_s3;
*use times34p;
  format nsrr_pctdursp_s3 8.2;
  nsrr_pctdursp_s3 = times34p;

*nsrr_pctdursp_sr;
*use timeremp;
  format nsrr_pctdursp_sr 8.2;
  nsrr_pctdursp_sr = timeremp;

*nsrr_ttlprdbd_f1;
*use timebedp;
  format nsrr_ttlprdbd_f1 8.2;
  nsrr_ttlprdbd_f1 = timebedp;  
  
  keep 
    nsrrid
    visitnumber
    nsrr_age
    nsrr_age_gt89
    nsrr_sex
    nsrr_race
    nsrr_ethnicity
    nsrr_bmi
    nsrr_bp_systolic
    nsrr_bp_diastolic
    nsrr_current_smoker
    nsrr_ever_smoker
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_ttldursp_f1
    nsrr_phrnumar_f1
    nsrr_flag_spsw
  	nsrr_ttleffsp_f1
	nsrr_ttllatsp_f1
	nsrr_ttlprdsp_s1sr
	nsrr_ttldursp_s1sr
	nsrr_ttldurws_f1
	nsrr_pctdursp_s1
	nsrr_pctdursp_s2
	nsrr_pctdursp_s3
	nsrr_pctdursp_sr
	nsrr_ttlprdbd_f1
    ;
run;

* concatenate shhs1, and shhs2 harmonized datasets;
data shhs_harmonized;
   set shhs1_harmonized shhs2_harmonized;
run;

*******************************************************************************;
* checking harmonized datasets ;
*******************************************************************************;

/* Checking for extreme values for continuous variables */

proc means data=shhs_harmonized;
VAR   nsrr_age
    nsrr_bmi
    nsrr_bp_systolic
    nsrr_bp_diastolic
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_ttldursp_f1
    nsrr_phrnumar_f1
  	nsrr_ttleffsp_f1
	nsrr_ttllatsp_f1
	nsrr_ttlprdsp_s1sr
	nsrr_ttldursp_s1sr
	nsrr_ttldurws_f1
	nsrr_pctdursp_s1
	nsrr_pctdursp_s2
	nsrr_pctdursp_s3
	nsrr_pctdursp_sr
	nsrr_ttlprdbd_f1;
run;

/* Checking categorical variables */

proc freq data=shhs_harmonized;
table   nsrr_age_gt89
    nsrr_sex
    nsrr_race
    nsrr_ethnicity
    nsrr_current_smoker
    nsrr_ever_smoker
    nsrr_flag_spsw;
run;

*******************************************************************************;
* make all variable names lowercase ;
*******************************************************************************;
  options mprint;
  %macro lowcase(dsn);
       %let dsid=%sysfunc(open(&dsn));
       %let num=%sysfunc(attrn(&dsid,nvars));
       %put &num;
       data &dsn;
             set &dsn(rename=(
          %do i = 1 %to &num;
          %let var&i=%sysfunc(varname(&dsid,&i));    /*function of varname returns the name of a SAS data set variable*/
          &&var&i=%sysfunc(lowcase(&&var&i))         /*rename all variables*/
          %end;));
          %let close=%sysfunc(close(&dsid));
    run;
  %mend lowcase;

  %lowcase(shhs1);
  %lowcase(shhs_exam2);
  %lowcase(shhs2);
  %lowcase(shhs_cvd_summary);
  %lowcase(shhs_cvd_event);
  %lowercase(shhs_harmonized);
  %lowercase(shhs_egg);
  

*******************************************************************************;
* export datasets to csv ;
*******************************************************************************;
  proc export data=shhs1
    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_releases\&release\shhs1-dataset-&release..csv"
    dbms=csv
    replace;
  run;

  proc export
    data=shhs_exam2
    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_releases\&release\shhs-interim-followup-dataset-&release..csv"
    dbms=csv
    replace;
  run;

  proc export
    data=shhs2
    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_releases\&release\shhs2-dataset-&release..csv"
    dbms=csv
    replace;
  run;

  proc export
    data=shhs_cvd_summary
    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_releases\&release\shhs-cvd-summary-dataset-&release..csv"
    dbms=csv
    replace;
  run;

  proc export
    data=shhs_cvd_event
    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_releases\&release\shhs-cvd-events-dataset-&release..csv"
    dbms=csv
    replace;
  run;

  proc export
    data=shhs_harmonized
    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_releases\&release\shhs-harmonized-dataset-&release..csv"
    dbms=csv
    replace;
  run;


* eeg exports;

	proc export
	    data=shhs_eeg
	    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\eeg-biomarkers-younes\_datasets\shhs1-eeg-biomarkers-dataset.csv"
	    dbms=csv
	    replace;
	  run;

	  proc export
	    data=shhs_eeg
	    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\eeg-biomarkers-younes\_archive\shhs1-eeg-biomarkers-dataset-&rundate..csv"
	    dbms=csv
	  run;

%let datetoday = %sysfunc(putn(%sysfunc(today()), mmddyy8.));
	  proc export
	    data=shhs_eeg
	    outfile="\\rfawin\bwh-sleepepi-shhs\nsrr-prep\_releases\&release.\eeg-biomarkers\shhs1-eeg-biomarkers-dataset-&datetoday..csv"
	    dbms=csv
	    replace;
	  run;
