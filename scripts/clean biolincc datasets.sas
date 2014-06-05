libname biolincc "\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_datasets\biolincc-master";

data shhs1_ecg;
	set biolincc.shhs1final_ecg_14aug2013_4260;
run;

data shhs1_psg;
	set biolincc.shhs1final_psg_15jan2014_5839(rename=(ppid2=pptid));
run;

data shhs1_other;
	set biolincc.shhs1final_15jan2014_5839;
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

data shhs_cvd;
	set biolincc.shhs_status_08apr2014_5837;
run;

data shhs1;
	merge shhs1_ecg shhs1_psg shhs1_other;
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

	rename overall = overall_shhs1;

	if yrssnr02 > 110 then yrssnr02 = .;
	if mi2slp02 = 9999 then mi2slp02 = .;
	if minfa10 = 9999 then minfa10 = .;
	if yrsns15 = 9999 then yrsns15 = .;
	if yrsns15 = 999 then yrsns15 = .;
	if napsmn15 = 9999 then napsmn15 = .;

	visitnumber = 1;

	drop uenrbp--UEROP5A repsgpptid responqa;
run;

data shhs2;
	merge shhs2_ecg shhs2_psg shhs2_other;
	by pptid;
run;

data shhs_demo;
	set shhs1;

	keep pptid race gender age_s1;
run;

data shhs2;
	merge shhs2(in=a) shhs_demo(in=b);
	by pptid;

	if a and b;

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

	visitnumber = 2;
	drop repsgpptid responqa;
run;

data shhs_cvd;
	merge shhs_cvd(in=a) shhs_demo(in=b);
	by pptid;

	if a and b;

	visitnumber = 3;

	drop omni;

run;
/*
proc export data=shhs1 outfile="\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.3.0\shhs1-dataset-0.3.0.beta5.csv" dbms=csv replace; run;

proc export data=shhs2 outfile="\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.3.0\shhs2-dataset-0.3.0.beta5.csv" dbms=csv replace; run;

proc export data=shhs_cvd outfile="\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.3.0\shhs-cvd-dataset-0.3.0.beta5.csv" dbms=csv replace; run;
*/
