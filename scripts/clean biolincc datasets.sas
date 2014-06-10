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
	if napshr15 = 9999 then napshr15 = .;
	if cigday15 = 9999 then cigday15 = .;
	if avesmk15 = 1980 then avesmk15 = .;
	if asalw15 = 9999 then asalw15 = .;
	if dias120 = 9999 then dias120 = .;
	if dias220 = 9999 then dias220 = .;
	if dias320 = 9999 then dias320 = .;
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
	if avoarnop5 le 0 then avoarnop5 = .;
	if avoarnop4 le 0 then avoarnop4 = .;

	visitnumber = 1;

	/*Corrects an erroneous value in the SHHS1 data*/
	if tfawea02 = 10 then tfawea02 = 2;

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

	if yrssnr02 > 110 then yrssnr02 = .;
	if mi2slp02 = 9999 then mi2slp02 = .;
	if minfa10 = 9999 then minfa10 = .;
	if yrsns15 = 9999 then yrsns15 = .;
	if yrsns15 = 999 then yrsns15 = .;
	if napsmn15 = 9999 then napsmn15 = .;
	if napshr15 = 9999 then napshr15 = .;
	if cigday15 = 9999 then cigday15 = .;
	if avesmk15 = 1980 then avesmk15 = .;
	if asalw15 = 9999 then asalw15 = .;
	if dias120 = 9999 then dias120 = .;
	if dias220 = 9999 then dias220 = .;
	if dias320 = 9999 then dias320 = .;
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
