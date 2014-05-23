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

	visitnumber = 1;
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

	visitnumber = 2;

run;

data shhs_cvd;
	merge shhs_cvd(in=a) shhs_demo(in=b);
	by pptid;

	if a and b;

	visitnumber = 3;

run;

proc export data=shhs1 outfile="\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.3.0\shhs1-dataset-0.3.0.beta3.csv" dbms=csv replace; run;

proc export data=shhs2 outfile="\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.3.0\shhs2-dataset-0.3.0.beta3.csv" dbms=csv replace; run;

proc export data=shhs_cvd outfile="\\rfa01\bwh-sleepepi-shhs\nsrr-prep\_releases\0.3.0\shhs-cvd-dataset-0.3.0.beta3.csv" dbms=csv replace; run;
