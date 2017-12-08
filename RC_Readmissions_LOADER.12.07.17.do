/*Stata*/
/* Data load and prep */ /* User-defined */ 
# delimit ;
cd "/Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD_RC_Predictors/Data";

/* Read data elements from hospital file, label variables, recode missing variables */
import delimited "NRD_2014_Hospital.csv";

rename v1   HOSP_BEDSIZE;
rename v2   H_CONTROL;
rename v3   HOSP_NRD;
rename v4   HOSP_URCAT4;
rename v5   HOSP_UR_TEACH;
rename v6   NRD_STRATUM;
rename v7   N_DISC_U;
rename v8   N_HOSP_U;
rename v9   S_DISC_U;
rename v10  S_HOSP_U;
rename v11  TOTAL_DISC;
rename v12  YEAR;

la var HOSP_BEDSIZE "Bed size of hospital/Sizes vary by region" ;
la var H_CONTROL "Control/ownership of hospital" ;
la var HOSP_NRD  "NRD hospital identifier" ;
la var HOSP_URCAT4 "Hospital urban-rural designation" ;
la var HOSP_UR_TEACH "Teaching status of urban hospitals" ;
la var NRD_STRATUM "NRD stratum used for weighting" ;
la var N_DISC_U "Number of universe discharges in NRD_STRATUM" ;
la var N_HOSP_U "Number of universe hospitals in NRD_STRATUM" ;
la var S_DISC_U "Number of sample discharges in NRD_STRATUM" ;
la var S_HOSP_U "Number of universe hospitals in NRD_STRATUM" ;
la var TOTAL_DISC "Total hospital discharges" ;
la var YEAR "Calendar year";

recode HOSP_BEDSIZE (-9 -8 -6 -5=.) ;
recode H_CONTROL (-9 -8 -6 -5=.) ;
recode HOSP_NRD (-9999 -8888 -6666=.) ;
recode HOSP_URCAT4 (-9 -8 -6 -5=.) ;
recode HOSP_UR_TEACH (-9 -8 -6 -5=.) ;
recode NRD_STRATUM (-9999 -8888 -6666=.) ;
recode N_DISC_U (-9999999 -8888888 -6666666=.) ;
recode N_HOSP_U (-999 -888 -666=.) ;
recode S_DISC_U (-9999999 -8888888 -6666666=.) ;
recode S_HOSP_U (-99999 -88888 -66666=.) ;
recode TOTAL_DISC (-99999 -88888 -66666=.) ;
recode YEAR (-999 -888 -666=.) ;

label define HOSP_BEDSIZE 
	1 "Small" 
	2 "Medium" 
	3 "Large", 	
	modify; 
label define H_CONTROL 
	1 "Government non federal" 
	2 "Private non-profit" 
	3 "Private invest own",
	modify; 
label define HOSP_URCAT4 
	1 "Large metropolitan areas with at least 1 million residents" 
	2 "Small metropolitan areas with less than 1 million residents" 
	3 "Micropolitan areas"
	4 "Not metropolitan or micropolitan"
	6 "Collapsed category for any urban-rural location (only applicable to the NEDS, beginning in 2014"
	7 "Collapsed category of small metropolitan and micropolitan, (only applicable to the NEDS, beginning in 2011"
	8 "Metropolitan, collapsed category of large and small metropolitan"
	9 "Non-metropolitan, collapsed category of micropolitan and non-urban",
	modify;
label define HOSP_UR_TEACH
	0 "Metropolitan non-teaching"
	1 "Metropolitan teaching"
	2 "Non-metropolitan hospital",
	modify;
	
label values HOSP_BEDSIZE HOSP_BEDSIZE;	
label values H_CONTROL H_CONTROL;
label values HOSP_URCAT4 HOSP_URCAT4;
label values HOSP_UR_TEACH HOSP_UR_TEACH;



gen DISCWT = 1 ;
gen byte INDEX_EVENT = 0 ;
gen byte READMIT = 0 ;

save "NRD_2014_Hospital.dta", replace;


/* Read data elements from core file */
/* Keep minimally required variables (to reduce memory used) */;
# delimit ;
import delimited "NRD_2014_Core.csv", clear;
rename v1 AGE; 
rename v2 WEEKEND;
rename v3 DIED;
rename v4 DISCWT; 
rename v5 DISPUNIFORM;
rename v6 DMONTH;
rename v7 DQTR; 
rename v8 DRG;
rename v9 DRG_NOPOA;
rename v10 DRGVER;
rename v11 DX1;
rename v12 DX2;
rename v13 DX3;
rename v14 DX4;
rename v15 DX5;
rename v16 DX6;
rename v17 DX7;
rename v18 DX8;
rename v19 DX9;
rename v20 DX10;
rename v21 DX11;
rename v22 DX12;
rename v23 DX13;
rename v24 DX14;
rename v25 DX15;
rename v26 DX16;
rename v27 DX17;
rename v28 DX18;
rename v29 DX19;
rename v30 DX20;
rename v31 DX21;
rename v32 DX22;
rename v33 DX23;
rename v34 DX24;
rename v35 DX25;
rename v36 DX26;
rename v37 DX27;
rename v38 DX28;
rename v39 DX29;
rename v40 DX30;
rename v75 ELECTIVE;
rename v80 FEMALE;
rename v82 HOSP_NRD;
rename v83 KEY_NRD;
rename v84 LOS;
rename v92 NRD_STRATUM;
rename v91 NRD_DAYSTOEVENT;
rename v93 NRD_VISITLINK;
rename v94 ORPROC;
rename v95 PAY1;
rename v96 PL_NCHS;
rename v97 PR1;
rename v98 PR2;
rename v99 PR3;
rename v100 PR4;
rename v101 PR5;
rename v102 PR6;
rename v103 PR7;
rename v104 PR8;
rename v105 PR9;
rename v106 PR10;
rename v107 PR11;
rename v108 PR12;
rename v109 PR13;
rename v110 PR14;
rename v111 PR15;
rename v142 REHABTRANSFER;
rename v143 RESIDENT;
rename v144 SAMEDAYEVENT;
rename v146 TOTCHG;
rename v147 YEAR;
rename v148 ZIPINC_QRTL;


label var AGE "Age in years at admission";
label var WEEKEND "Admission day is a weekend" ;
label var DIED "Died during hospitalization";
label var DISCWT "Weight to discharges in AHA universe";
label var DISPUNIFORM "Disposition of patient (uniform)";
label var DMONTH "Discharge month";
label var DQTR "Discharge quarter";
label var DRG  "Diagnosis related group in use on discharge date";
label var DRG_NOPOA  "Diagnosis related group assignment made without the use of the present on admission flags for the diagnoses";
label var DRGVER "Group version in use on discharge date";
label var DX1                      "Diagnosis 1" ;
label var DX2                      "Diagnosis 2" ;
label var DX3                      "Diagnosis 3" ;
label var DX4                      "Diagnosis 4" ;
label var DX5                      "Diagnosis 5" ;
label var DX6                      "Diagnosis 6" ;
label var DX7                      "Diagnosis 7" ;
label var DX8                      "Diagnosis 8" ;
label var DX9                      "Diagnosis 9" ;
label var DX10                     "Diagnosis 10" ;
label var DX11                     "Diagnosis 11" ;
label var DX12                     "Diagnosis 12" ;
label var DX13                     "Diagnosis 13" ;
label var DX14                     "Diagnosis 14" ;
label var DX15                     "Diagnosis 15" ;
label var DX16                     "Diagnosis 16" ;
label var DX17                     "Diagnosis 17" ;
label var DX18                     "Diagnosis 18" ;
label var DX19                     "Diagnosis 19" ;
label var DX20                     "Diagnosis 20" ;
label var DX21                     "Diagnosis 21" ;
label var DX22                     "Diagnosis 22" ;
label var DX23                     "Diagnosis 23" ;
label var DX24                     "Diagnosis 24" ;
label var DX25                     "Diagnosis 25" ;
label var DX26                     "Diagnosis 26" ;
label var DX27                     "Diagnosis 27" ;
label var DX28                     "Diagnosis 28" ;
label var DX29                     "Diagnosis 29" ;
label var DX30                     "Diagnosis 30" ;
la var ELECTIVE "Elective versus non-elective admission";
la var FEMALE "Indicator of sex";
la var HOSP_NRD "NRD hospital identifier";
la var KEY_NRD "NRD record identifier";
la var LOS "Length of Stay";
la var NRD_STRATUM "NRD stratum used for weighting";
la var NRD_DAYSTOEVENT "Timing variable used to identify days between admissions";
la var NRD_VISITLINK  "NRD_VisitLink";
la var ORPROC "Major operating room procedure indicator";
la var PAY1 "Primary expected payer (uniform)";
la var PL_NCHS "Patient Location: NCHS Urban-Rural Code";
la var PR1 "Procedure 1" ;
la var PR2 "Procedure 2" ;
la var PR3 "Procedure 3" ;
la var PR4 "Procedure 4" ;
la var PR5 "Procedure 5" ;
la var PR6 "Procedure 6" ;
la var PR7 "Procedure 7" ;
la var PR8 "Procedure 8" ;
la var PR9 "Procedure 9" ;
la var PR10 "Procedure 10" ;
la var PR11 "Procedure 11" ;
la var PR12 "Procedure 12" ;
la var PR13 "Procedure 13" ;
la var PR14 "Procedure 14" ;
la var PR15 "Procedure 15" ;
la var REHABTRANSFER "A combined record involving rehab transfer";
la var RESIDENT "Patient State is the same as Hospital State" ;
la var SAMEDAYEVENT "Transfer flag indicating combination of discharges involve same day events" ;
la var TOTCHG "Total charges (cleaned)";
la var YEAR "Calendar year";
la var ZIPINC_QRTL "Median household income national quartile for patient ZIP Code" ;

/* Convert special values to missing values */
recode AGE ( -99 -88 -66 =.);
recode DIED ( -9 -8 -6 -5 = . ) ;
recode DMONTH ( -9 -8 -6 -5 = . ) ;
recode LOS ( -9999 -8888 -6666 = . ) ;
recode NRD_DAYSTOEVENT ( -999999999 -888888888 -666666666 = . ) ;
recode WEEKEND (-9 -8 -6 -5=.) ;
recode DMONTH (-9 -8 -6 -5=.) ;
recode DISPUNIFORM (-9 -8 -6 -5=.) ;
recode DQTR (-9 -8 -6 -5=.) ;
recode ELECTIVE (-9 -8 -6 -5=.) ;
recode FEMALE (-9 -8 -6 -5=.) ;
recode HOSP_NRD (-9999 -8888 -6666=.) ;
recode KEY_NRD (-99999999999999 -88888888888888 -66666666666666=.) ;
recode LOS (-9999 -8888 -6666=.) ;
recode NRD_DAYSTOEVENT (-999999999 -888888888 -666666666=.) ;
recode NRD_STRATUM (-9999 -8888 -6666=.) ;
recode ORPROC (-9 -8 -6 -5=.) ;
recode PAY1 (-9 -8 -6 -5=.) ;
recode PL_NCHS (-99 -88 -66=.) ;
recode RESIDENT (-9 -8 -6 -5=.) ;
recode TOTCHG (-999999999 -888888888 -666666666=.) ;
recode YEAR (-999 -888 -666=.) ;
recode ZIPINC_QRTL(-9 -8 -6 -5=.) ;

/* recodes AGE -> AGE_CAT and FEMALE -> SEX*/
recode AGE 
	(18/24=0 "< 25 yo") 
	(25/34=1 "25-34 yo") 
	(35/44=2 "35-44 yo") 
	(45/54=3 "45-54 yo") 
	(55/64=4 "55-64 yo") 
	(65/74=5 "65-74 yo") 
	(75/120=6 "< 75 yo")
	(else=7 "Unknown/NA"),
gen (AGE_CAT);
	recode FEMALE 
	(0=0 "Male")
	(1=1 "Female") 
	(.=2 "Unknown"), 
	gen (SEX) ;
recode PAY1
	(3=0 "Private Insurance")
	(1=1 "Medicare")
	(2=2 "Medicaid") 
	(4=3 "Self-pay") 
	(else=4 "Other/Unknown"),
	gen (PAYOR);
	
	
/* label variables*/
	
#delimit;	
label define WEEKEND 
	0 "Admission day is not a weekend" 
	1 "Admission day is a weekend",
	modify; 
label define DIED
	0 "Did not die during hospitalization" 
	1 "Died during hospitalization",
	modify;
label define DISPUNIFORM 
	1  "Discharged routine"
	2  "Transfer short-term hospital" 
	5  "Transfer other"
	6  "Transfer Home Health Care/HHC" 
	7  "Left against medical advice"
	20 "Died in Hospital", 
	modify;
label define DMONTH
	1 "January"
	2 "February"
	3 "March"
	4 "April" 
	5 "May" 
	6 "June" 
	7 "July" 
	8 "August"
	9 "September" 
	10 "October" 
	11 "November"
	12 "December",
	modify;	
label define DQTR 
	1 "First quarter (Jan - Mar)" 
	2  "Second quarter (Apr - Jun)"
	3 "Third quarter (Jul - Sep)" 
	4 "Fourth quarter (Oct - Dec)",
	modify;
label define ORPROC
	0 "No major operating room procedure reported on discharge record"
	1 "Major operating room procedure reported on discharge record", 
	modify;
label define REHABTRANSFER	
	0 "Not a transfer to rehab"
	1 "Tranfer to rehabilitation, evaluation or aftercare",
	modify;
label define RESIDENT
	0 "Non-resident of the state where patient received care"
	1 "Resident of the state where patient received care",
	modify;
label define ZIPINC_QRTL
	1 "0-25th percentile"
	2 "26-50th percentile"
	3 "51-75th percentile"
	5 ">75th percentile",
	modify;

#delimit ;	
label values WEEKEND WEEKEND;
label values DIED DIED;
label values DISPUNIFORM DISPUNIFORM;
label values DMONTH DMONTH;	
label values DQTR DQTR;
label values ORPROC ORPROC;
label values REHABTRANSFER;
label values RESIDENT RESIDENT;
label values ZIPINC_QRTL ZIPINC_QRTL;	


/* Identify index events 0 if noindex_event, 1 if index_event */
/* Only works for procedures.... section needs to be changed for each new procedure */
generate INDEX_EVENT=0;
rename PR1 PR0;
destring PR0, generate(PR1) force;
foreach x of varlist PR1-PR15 {;
  replace INDEX_EVENT=1 if `x'==5771 & 
			AGE >= 18 & 
				inrange(DMONTH, 1, 11) & 
					DIED == 0 & 
						LOS < .;
  replace INDEX_EVENT=1 if `x'==5779 &
			AGE >= 18 & 
				inrange(DMONTH, 1, 11) & 
					DIED == 0 & 
						LOS < .;
};
generate MINIMALLY_INVASIVE=0;
foreach x of varlist PR1-PR15 {;
  replace MINIMALLY_INVASIVE=1 if `x'==1742 |
	`x'==5451 |
		`x'==5421;
};
generate ROBOT_ASSISTED=0;
foreach x of varlist PR1-PR15 {;
  replace ROBOT_ASSISTED=1 if `x'==1742;
};

#delimit;
/* Save datasets for merge */
save "NRD_2014_Core.dta", replace;


#delimit;    
use "NRD_2014_Core.dta", replace;  
drop DISCWT LOS NRD_STRATUM INDEX_EVENT ; 
save "NRD_2014_Core_r.dta", replace ;

/* Load index events and calculate discharge dates */
use "NRD_2014_Core.dta", clear ;
keep if INDEX_EVENT == 1 ;
gen DISCHARGE_DATE = NRD_DAYSTOEVENT + LOS;

/* Merge index and readmission events */
/* Keeps only the HOSP_NRD, KEY_NRD and DISCHARGE_DATE (generated above)*/
/* Changes HOSP_NRD and KEY_NRD to HOSP_NRD_INDEX */
keep HOSP_NRD KEY_NRD NRD_VISITLINK DISCHARGE_DATE ; 
rename HOSP_NRD HOSP_NRD_INDEX ;
rename KEY_NRD KEY_NRD_INDEX ;
joinby NRD_VISITLINK using "NRD_2014_Core_r.dta" ;
rm "NRD_2014_Core_r.dta";


/* Select all readmissions within 30 days */
/* Not a self merge */
#delimit;
keep if KEY_NRD != KEY_NRD_INDEX & 
	NRD_DAYSTOEVENT >= DISCHARGE_DATE &
		NRD_DAYSTOEVENT <= ( DISCHARGE_DATE + 30 ) ;
		
/* IDENTIFY AND CODE READMISSIONS */
#delimit ;
sort HOSP_NRD_INDEX KEY_NRD_INDEX NRD_DAYSTOEVENT ;
by HOSP_NRD_INDEX KEY_NRD_INDEX: gen f_num = 1 if _n == 1; 
gen EVENT=0;
replace EVENT=1 if f_num==1;
replace EVENT=0 if f_num==.;
keep if f_num == 0|1 ;

/* Save readmission events */
drop HOSP_NRD KEY_NRD ;
	rename HOSP_NRD_INDEX HOSP_NRD ;
	rename KEY_NRD_INDEX KEY_NRD ;
save "NRD_2014_Core_readmit.dta", replace ;

/* Load core file and subset by index events */
use "NRD_2014_Core.dta", replace ; 
	sort HOSP_NRD KEY_NRD ;
		
/* not sure about this - Will have to merge but also keep the no match since they are the readmissions observations! we can look this up tomorrow, you probably know how - i am pretty novice with stata's functions */
#delimit ;
merge m:1 HOSP_NRD KEY_NRD using "NRD_2014_Core.dta" ; 
	gen READMIT = ( _merge == 3 ); 
			drop _merge;
keep if READMIT ==1
save "NRD_2014_Core_readmit.dta", replace;

*delete duplicate NRD_VISITLINK and merge with CCI database and save and overwrite with a new readmit.CCI */
#delimit ;
use "NRD_2014_Core_readmit.dta", clear;
	bysort NRD_VISITLINK: gen n=_n ;
		tab n, missing;
			keep if n==1;
				merge 1:1 NRD_VISITLINK using "NRD_2014_Core_CCI.dta";
					drop _merge;
save "NRD_2014_Core_readmit.CCI.dta", replace;

/*****************/
/* Calculate CCI */
	
# delimit;
use "NRD_2014_Core_Readmit.dta", clear;

gen MI=0;
gen CHF=0;
gen PVD=0;
gen CVD=0; 
gen DEMENTIA=0;
gen CPD=0;
gen RHEUM=0;
gen PUD=0;
gen LIVER1=0;
gen DM1=0;
gen DM2=0;
gen PLEGIA=0;
gen RENAL=0;
gen LIVER2=0;
gen AIDS=0;
gen METS=0;

/* In the following codes, replace "`icd_code'" with variables showing ICD 9 codes */
# delimit;
foreach icd_code of varlist DX1-DX30{;
	replace MI=1 if 
		substr(`icd_code',1,3)=="410"| 
		substr(`icd_code',1,3)=="412";
		
	replace CHF=1 if 
		substr(`icd_code',1,3)=="428" ;
	
	replace PVD=1 if 
		substr(`icd_code',1,5)=="443.9"| 
		substr(`icd_code',1,5)=="785.4"| 
		substr(`icd_code',1,5)=="V43.4"|
		substr(`icd_code',1,3)=="441"; 
								
	replace CVD=1 if 
		substr(`icd_code',1,3)=="431"| 
		substr(`icd_code',1,5)=="436";
			
	replace CVD=1 if 
		substr(`icd_code',1,2)=="43"|
		substr(`icd_code',3,1)=="3"| 
		substr(`icd_code',3,1)=="4"| 
		substr(`icd_code',3,1)=="5"| 
		substr(`icd_code',3,1)=="7"| 
		substr(`icd_code',3,1)=="8";
					
	replace DEMENTIA=1 if 
		substr(`icd_code',1,3)=="290"; 

	
	replace CPD=1 if 
		substr(`icd_code',1,3)=="490"|
		substr(`icd_code',1,3)=="491"| 
		substr(`icd_code',1,3)=="492"| 
		substr(`icd_code',1,3)=="493"| 
		substr(`icd_code',1,3)=="494"| 
		substr(`icd_code',1,3)=="495"| 
		substr(`icd_code',1,3)=="496"| 
		substr(`icd_code',1,3)=="500"| 
		substr(`icd_code',1,3)=="501"|
		substr(`icd_code',1,3)=="502"| 
		substr(`icd_code',1,3)=="503"| 
		substr(`icd_code',1,3)=="504"| 
		substr(`icd_code',1,3)=="505";
													
	replace CPD=1 if 
		substr(`icd_code',1,4)=="5064"; 

	replace RHEUM=1 if 
		substr(`icd_code',1,4)=="7100"| 
		substr(`icd_code',1,4)=="7101"| 
		substr(`icd_code',1,4)=="7104"| 
		substr(`icd_code',1,4)=="7140"| 
		substr(`icd_code',1,4)=="7141"| 
		substr(`icd_code',1,5)=="7142";
											
	replace RHEUM=1 if 
		substr(`icd_code',1,5)=="71481"|
		substr(`icd_code',1,3)=="725";
		
	replace PUD=1 if 
		substr(`icd_code',1,3)=="531" | 
		substr(`icd_code',1,3)=="532" | 
		substr(`icd_code',1,3)=="533" | 
		substr(`icd_code',1,3)=="534";
		
	replace LIVER1=1 if 
		substr(`icd_code',1,3)=="571";
	
	replace LIVER1=1 if 
		substr(`icd_code',5,1)=="2"| 
		substr(`icd_code',5,1)=="4"| 
		substr(`icd_code',5,1)=="5"| 
		substr(`icd_code',5,1)=="6";
				
	replace DM1=1 if 
		substr(`icd_code',1,3)=="250";
	
	replace DM1=1 if 
		substr(`icd_code',5,1)=="0"| 
		substr(`icd_code',5,1)=="1"| 
		substr(`icd_code',5,1)=="2"| 
		substr(`icd_code',5,1)=="3"| 
		substr(`icd_code',5,1)=="7";
					
	replace DM2=1 if 
		substr(`icd_code',1,3)=="250";
	
	replace DM2=1 if 
		substr(`icd_code',5,1)=="4"| 
		substr(`icd_code',5,1)=="5"| 
		substr(`icd_code',5,1)=="6";
			
	replace PLEGIA=1 if 
		substr(`icd_code',1,4)=="3441";
	
	replace PLEGIA=1 if 
		substr(`icd_code',1,3)=="342";

	replace RENAL=1 if 
		substr(`icd_code',1,3)=="582"| 
		substr(`icd_code',1,3)=="583"&
		substr(`icd_code',5,1)!="8"& 
		substr(`icd_code',5,1)!="9";
		
	replace RENAL=1 if 
		substr(`icd_code',1,3)=="585"| 
		substr(`icd_code',1,3)=="586"| 
		substr(`icd_code',1,3)=="588";

	replace LIVER2=1 if 
		substr(`icd_code',1,3)=="572"&
		substr(`icd_code',5,1)!="0"| 
		substr(`icd_code',5,1)!="1"| 
		substr(`icd_code',5,1)!="9";
				
	replace LIVER2=1 if 
		substr(`icd_code',1,4)=="4560"| 
		substr(`icd_code',1,4)=="4561"; 
		
	replace LIVER2=1 if 
		substr(`icd_code',1,5)=="45620"| 
		substr(`icd_code',1,5)=="45621"; 

	replace AIDS=1 if 
		substr(`icd_code',1,3)=="042"| 
		substr(`icd_code',1,3)=="043"| 
		substr(`icd_code',1,3)=="044";
			
	replace METS=1 if 
		substr(`icd_code',1,2)=="19"&
		substr(`icd_code',3,1)*1=="6"|
		substr(`icd_code',3,1)=="7"|
		substr(`icd_code',3,1)=="8";

	replace METS=1 if 
		substr(`icd_code',1,2)=="19" &
		substr(`icd_code',3,1)=="9" &
		substr(`icd_code',5,1)*1=="0"|
		substr(`icd_code',5,1)*1=="1";
	};
			
egen MI_TOT = total(MI), by(NRD_VISITLINK) ;
egen CHF_TOT = total(CHF), by(NRD_VISITLINK) ;
egen PVD_TOT = total(PVD), by(NRD_VISITLINK) ; 
egen CVD_TOT = total(CVD), by(NRD_VISITLINK) ;
egen DEMENTIA_TOT = total(DEMENTIA), by(NRD_VISITLINK) ;
egen CPD_TOT = total(CPD), by(NRD_VISITLINK) ;
egen RHEUM_TOT = total(RHEUM), by(NRD_VISITLINK) ;
egen PUD_TOT = total(PUD), by(NRD_VISITLINK) ;
egen LIVER1_TOT = total(LIVER1), by(NRD_VISITLINK) ;
egen DM1_TOT = total(DM1), by(NRD_VISITLINK) ;
egen DM2_TOT = total(DM2), by(NRD_VISITLINK) ;
egen PLEGIA_TOT = total(PLEGIA), by(NRD_VISITLINK) ;
egen RENAL_TOT = total(RENAL), by(NRD_VISITLINK) ;
egen LIVER2_TOT = total(LIVER2), by(NRD_VISITLINK) ;
egen AIDS_TOT = total(AIDS), by(NRD_VISITLINK) ;
egen METS_TOT = total(METS), by(NRD_VISITLINK) ;

replace MI_TOT=1 if MI_TOT>0;
replace CHF_TOT=1 if CHF_TOT>0;
replace PVD_TOT=1 if PVD_TOT>0;
replace CVD_TOT=1 if CVD_TOT>0;
replace DEMENTIA_TOT=1 if DEMENTIA_TOT>0;
replace CPD_TOT=1 if CPD_TOT>0;
replace RHEUM_TOT=1 if RHEUM_TOT>0;
replace PUD_TOT=1 if PUD_TOT>0;
replace LIVER1_TOT=1 if LIVER1_TOT>0;
replace DM1_TOT=1 if DM1_TOT>0;
replace DM2_TOT=1 if DM2_TOT>0;
replace PLEGIA_TOT=1 if PLEGIA_TOT>0;
replace RENAL_TOT=1 if RENAL_TOT>0;
replace LIVER2_TOT=1 if LIVER2_TOT>0;
replace AIDS_TOT=1 if AIDS_TOT>0;
replace METS_TOT=1 if METS_TOT>0;

gen CHARLSON=MI_TOT+CHF_TOT+PVD_TOT+CVD_TOT+DEMENTIA_TOT+CPD_TOT+RHEUM_TOT+PUD_TOT+LIVER1_TOT+DM1_TOT+(DM2_TOT*2)+(PLEGIA_TOT*2)+(RENAL_TOT*2)+(LIVER2_TOT*3)+(AIDS_TOT*6);
la var CHARLSON "Charlson comorbidity index";
tab CHARLSON, missing;	

save "NRD_2014_Core_Readmit.dta", replace;

#delimit;
use "NRD_2014_Core_Readmit.dta", clear;

/* Second generate variables according to complications */
gen GI_OBSTRUCTION=0;
gen CDIFF=0;
gen SEPSIS=0;
gen BACTEREMIA=0; 
gen POSTOP_INFECTION=0;
gen UTI=0;
gen URINARY_CATHETER_INFECTION=0;
gen PYELONEPHRITIS=0;
gen URINARY_COMPLICATION_NOS=0;
gen ABCESS=0;
gen WOUND_COMPLICATIONS=0;
gen SEROMA=0;
gen CENTRAL_CATHETER_INFECTION=0;
gen FOREIGN_BODY_OR_OTHER_NOS_COMPLICATION=0;
gen URETERAL_URETHRAL_STRICTURE=0;
gen STOMA_COMPLICATION=0;
gen DVT=0;
gen PULMONARY_EMBOLISM=0;
gen MYOCARDIAL_INFARCTION_CAD_COMPLICATION=0;
gen HEMORRHAGE_OR_ACCIDENTAL_LACERATION=0;
gen PNEUMONIA_PNEUMOTHORAX=0;

/* label newly created variables */

#delimit ;
la var OBSTRUCTION "Obstruction GI NOS Or Ileus";
la var CDIFF "CDiff Infection" ;
la var SEPSIS "Sepsis" ;
la var BACTEREMIA "Bacteremia" ;
la var POSTOP_INFECTION "Postop_Infection" ;
la var UTI "Uti" ;
la var URINARY_CATHETER_INFECTION "Urinary Catheter Infection" ;
la var PYELONEPHRITIS "Pyelonephritis" ;
la var URINARY_COMPLICATION_NOS "Urinary Complication Nos" ;
la var ABCESS "Abcess" ;
la var WOUND_COMPLICATIONS "Wound Complications" ;
la var SEROMA "Seroma" ;
la var CENTRAL_CATHETER_INFECTION "Central Catheter Infection" ;
la var FOREIGN_BODY_OR_OTHER_NOS_COMPLICATION "Foreign Body Or Other Nos Complication" ;
la var URETERAL_URETHRAL_STRICTURE "Ureteral Or Urethral Stricture"
la var STOMA_COMPLICATION "Stoma complication"  ;
la var DVT "Deep vein thrombosis" ;
la var PULMONARY_EMBOLISM "Pulmonary Embolism";
la var MYOCARDIAL_INFARCTION_CAD_COMPLICATION "Myocardial infarction or coronary artery disease complication" ;
la var HEMORRHAGE_OR_ACCIDENTAL_LACERATION "Hemorrhage or accidental laceration" ;
la var PNEUMONIA_PNEUMOTHORAX "Pneumonia or pneumothorax" ;

/* In the following codes, replace "`icd_code'" with variables showing ICD 9 codes */
foreach icd_code of varlist DX1-DX30{;
	replace OBSTRUCTION=1 if 
		substr(`icd_code',1,5)=="55221"|
		substr(`icd_code',1,4)=="5528"|
		substr(`icd_code',1,3)=="560"|
		substr(`icd_code',1,4)=="5601"|
		substr(`icd_code',1,4)=="56010"|
		substr(`icd_code',1,5)=="56059"|
		substr(`icd_code',1,5)=="56081"|
		substr(`icd_code',1,4)=="5609"|
		substr(`icd_code',1,4)=="9974"|
		substr(`icd_code',1,5)=="99749";
		
	replace CDIFF=1 if 
		substr(`icd_code',1,5)=="00845";
	
	replace SEPSIS=1 if 
		substr(`icd_code',1,3)=="038"| 
		substr(`icd_code',1,4)=="0380"|
		substr(`icd_code',1,5)=="03810"|
		substr(`icd_code',1,5)=="03811"|
		substr(`icd_code',1,5)=="03812"|
		substr(`icd_code',1,5)=="03819"|
		substr(`icd_code',1,4)=="0382"|
		substr(`icd_code',1,4)=="0383"|
		substr(`icd_code',1,4)=="0384"|
		substr(`icd_code',1,5)=="03840"| 
		substr(`icd_code',1,5)=="03841"|
		substr(`icd_code',1,5)=="03842"|
		substr(`icd_code',1,5)=="03843"|
		substr(`icd_code',1,5)=="03849"|
		substr(`icd_code',1,4)=="0388"|
		substr(`icd_code',1,4)=="0389"|
		substr(`icd_code',1,5)=="67020"|
		substr(`icd_code',1,5)=="67022"|
		substr(`icd_code',1,5)=="67024"|
		substr(`icd_code',1,5)=="77181"|
		substr(`icd_code',1,5)=="99591";	
		
	replace BACTEREMIA=1 if 
		substr(`icd_code',1,4)=="7907";
			
	replace POSTOP_INFECTION=1 if 
		substr(`icd_code',1,5)=="99859";
					
	replace UTI=1 if 
		substr(`icd_code',1,5)=="99664"|
		substr(`icd_code',1,4)=="5990";

	replace URINARY_CATHETER_INFECTION=1 if 
		substr(`icd_code',1,5)=="99631"|
		substr(`icd_code',1,5)=="99639"| 
		substr(`icd_code',1,5)=="99664"|
		substr(`icd_code',1,5)=="99665"|
		substr(`icd_code',1,5)=="99676";
					
	replace PYELONEPHRITIS=1 if 
		substr(`icd_code',1,4)=="5901"|
		substr(`icd_code',1,5)=="59010"|
		substr(`icd_code',1,5)=="59011"|
		substr(`icd_code',1,4)=="5902"|
		substr(`icd_code',1,5)=="59080"|
		substr(`icd_code',1,4)=="5909"| ;

	replace URINARY_COMPLICATION_NOS=1 if 
		substr(`icd_code',1,4)=="9975";	
			
	replace ABCESS=1 if 
		substr(`icd_code',1,5)=="56722"|
		substr(`icd_code',1,5)=="56731"| 
		substr(`icd_code',1,5)=="56738"|
		substr(`icd_code',1,4)=="5902"|
		substr(`icd_code',1,5)=="59080"|
		substr(`icd_code',1,4)=="5909";
						
	replace WOUND_COMPLICATIONS=1 if 
		substr(`icd_code',1,4)=="9983"|
		substr(`icd_code',1,5)=="99830"| 
		substr(`icd_code',1,5)=="99831"|
		substr(`icd_code',1,5)=="99832"|
		substr(`icd_code',1,5)=="99883";

	replace SEROMA=1 if 
		substr(`icd_code',1,5)=="99813"|
		substr(`icd_code',1,5)=="99851";

	replace CENTRAL_CATHETER_INFECTION=1 if 
		substr(`icd_code',1,4)=="9993"|
		substr(`icd_code',1,5)=="99931"|
		substr(`icd_code',1,5)=="99662";

	replace FOREIGN_BODY_OR_OTHER_NOS_COMPLICATION=1 if 
		substr(`icd_code',1,4)=="9984"|
		substr(`icd_code',1,4)=="9998";

	replace URETERAL_URETHRAL_STRICTURE=1 if 
		substr(`icd_code',1,4)=="5933"|
		substr(`icd_code',1,4)=="5982";
	
	replace STOMA_COMPLICATION=1 if 
		substr(`icd_code',1,5)=="59681"|
		substr(`icd_code',1,5)=="59683"|
		substr(`icd_code',1,5)=="59682";

	replace DVT=1 if 
		substr(`icd_code',1,5)=="45350"|
		substr(`icd_code',1,5)=="45341"|
		substr(`icd_code',1,5)=="45342"|
		substr(`icd_code',1,5)=="45381"| 
		substr(`icd_code',1,5)=="45382"| 
		substr(`icd_code',1,5)=="45383"| 
		substr(`icd_code',1,5)=="45384"| 
		substr(`icd_code',1,5)=="45485"| 
		substr(`icd_code',1,5)=="45386"| 
		substr(`icd_code',1,5)=="45387"| 
		substr(`icd_code',1,5)=="45389";

	replace PULMONARY_EMBOLISM=1 if 
		substr(`icd_code',1,5)=="41511"|
		substr(`icd_code',1,5)=="41512"|
		substr(`icd_code',1,5)=="41519"|
		substr(`icd_code',1,5)=="67300"| 
		substr(`icd_code',1,5)=="67301"| 
		substr(`icd_code',1,5)=="67302"| 
		substr(`icd_code',1,5)=="67303"| 
		substr(`icd_code',1,5)=="67304"| 
		substr(`icd_code',1,5)=="67310"| 
		substr(`icd_code',1,5)=="67311"| 
		substr(`icd_code',1,5)=="67312"|
		substr(`icd_code',1,5)=="67313"|
		substr(`icd_code',1,5)=="67314"| 
		substr(`icd_code',1,5)=="67320"| 
		substr(`icd_code',1,5)=="67321"| 
		substr(`icd_code',1,5)=="67322"| 
		substr(`icd_code',1,5)=="67323"| 
		substr(`icd_code',1,5)=="67324"| 
		substr(`icd_code',1,5)=="67330"| 
		substr(`icd_code',1,5)=="67331"|
		substr(`icd_code',1,5)=="67332"|
		substr(`icd_code',1,5)=="67333"|
		substr(`icd_code',1,5)=="67334"|
		substr(`icd_code',1,5)=="67380"|
		substr(`icd_code',1,5)=="67381"|
		substr(`icd_code',1,5)=="67382"|
		substr(`icd_code',1,5)=="67383"|
		substr(`icd_code',1,5)=="67384";

	replace MYOCARDIAL_INFARCTION_CAD_COMPLICATION=1 if 
		substr(`icd_code',1,5)=="41001"|
		substr(`icd_code',1,5)=="41011"|
		substr(`icd_code',1,5)=="41041"|
		substr(`icd_code',1,5)=="41061"| 
		substr(`icd_code',1,5)=="41071"| 
		substr(`icd_code',1,5)=="41091"| 
		substr(`icd_code',1,5)=="41401";

	replace PHLEBITIS=1 if 
		substr(`icd_code',1,4)=="9972"|
		substr(`icd_code',1,4)=="9992";

	replace CARDIAC_COMPLICATION_NOS=1 if 
		substr(`icd_code',1,4)=="9971";
	
	replace HEMORRHAGE_OR_ACCIDENTAL_LACERATION=1 if 
		substr(`icd_code',1,5)=="56881"|
		substr(`icd_code',1,4)=="5967"|
		substr(`icd_code',1,5)=="60883"|
		substr(`icd_code',1,4)=="9981"|
		substr(`icd_code',1,5)=="99811"|
		substr(`icd_code',1,5)=="99812"|
		substr(`icd_code',1,4)=="9982";
							
	replace PNEUMONIA_PNEUMOTHORAX=1 if 
		substr(`icd_code',1,4)=="9973"|
		substr(`icd_code',1,5)=="99731"|
		substr(`icd_code',1,5)=="99739"|
		substr(`icd_code',1,4)=="5121";
};


#delimit ;
label define OBSTRUCTION
	0 "no" 
	1 "yes",
	modify; 
label define CDIFF
	0 "no" 
	1 "yes",
	modify; 
label define SEPSIS
	0 "no" 
	1 "yes",
	modify; 
label define BACTEREMIA
	0 "no" 
	1 "yes",
	modify; 
label define POSTOP_INFECTION
	0 "no" 
	1 "yes",
	modify; 
label define UTI
	0 "no" 
	1 "yes",
	modify; 
label define URINARY_CATHETER_INFECTION
	0 "no" 
	1 "yes",
	modify; 
label define PYELONEPHRITIS
	0 "no" 
	1 "yes",
	modify; 
label define URINARY_COMPLICATION_NOS
	0 "no" 
	1 "yes",
	modify; 
label define ABCESS
	0 "no" 
	1 "yes",
	modify; 
label define WOUND_COMPLICATIONS
	0 "no" 
	1 "yes",
	modify; 
label define SEROMA
	0 "no" 
	1 "yes",
	modify; 
label define CENTRAL_CATHETER_INFECTION
	0 "no" 
	1 "yes",
	modify; 
label define FOREIGN_BODY_OR_OTHER_NOS_COMPLICATION
	0 "no" 
	1 "yes",
	modify; 
label define URETERAL_URETHRAL_STRICTURE
	0 "no" 
	1 "yes",
	modify; 
label define STOMA_COMPLICATION
	0 "no" 
	1 "yes",
	modify; 
label define DVT
	0 "no" 
	1 "yes",
	modify; 
label define PULMONARY_EMBOLISM
	0 "no" 
	1 "yes",
	modify; 
label define MYOCARDIAL_INFARCTION_CAD_COMPLICATION
	0 "no" 
	1 "yes",
	modify; 
label define HEMORRHAGE_OR_ACCIDENTAL_LACERATION
	0 "no" 
	1 "yes",
	modify; 
label define PNEUMONIA_PNEUMOTHORAX 
	0 "no" 
	1 "yes",
	modify; 

label values OBSTRUCTION OBSTRUCTION ;
label values CDIFF CDIFF ;
label values SEPSIS SEPSIS ;
label values BACTEREMIA BACTEREMIA  ;
label values POSTOP_INFECTION POSTOP_INFECTION;
label values UTI UTI ;
label values URINARY_CATHETER_INFECTION URINARY_CATHETER_INFECTION;
label values PYELONEPHRITIS PYELONEPHRITIS ;
label values URINARY_COMPLICATION_NOS URINARY_COMPLICATION_NOS;
label values ABCESS ABCESS ;
label values WOUND_COMPLICATIONS WOUND_COMPLICATIONS;
label values SEROMA SEROMA  ;
label values CENTRAL_CATHETER_INFECTION CENTRAL_CATHETER_INFECTION;
label values FOREIGN_BODY_OR_OTHER_NOS_COMPLICATION FOREIGN_BODY_OR_OTHER_NOS_COMPLICATION;
label values URETERAL_URETHRAL_STRICTURE URETERAL_URETHRAL_STRICTURE;
label values STOMA_COMPLICATION STOMA_COMPLICATION;
label values DVT DVT ;
label values PULMONARY_EMBOLISM PULMONARY_EMBOLISM;
label values MYOCARDIAL_INFARCTION_CAD_COMPLICATION MYOCARDIAL_INFARCTION_CAD_COMPLICATION;
label values HEMORRHAGE_OR_ACCIDENTAL_LACERATION HEMORRHAGE_OR_ACCIDENTAL_LACERATION;
label values PNEUMONIA_PNEUMOTHORAX  PNEUMONIA_PNEUMOTHORAX  ;

/*Note that all of the above complications are in the same admission as the INDEX EVENT*/

save "NRD_2014_Core_Readmit.dta", replace ;

/*Keeps only subset of variables and saves "trimmed version of file to save memory */
/*Edit variables below to add more */
#delimit ;
use "NRD_2014_Core_Readmit.dta", clear;	
	keep
		AGE
		AGE_CAT
		WEEKEND 
		DIED 
		DISCWT 
		DISPUNIFORM 
		DMONTH 
		DQTR 
		DRG
		DRG_NOPOA
		DRGVER
		DX1
		ELECTIVE 
		FEMALE
		SEX
		HOSP_NRD 
		KEY_NRD 
		LOS
		NRD_DAYSTOEVENT 
		NRD_STRATUM 
		NRD_VISITLINK 
		ORPROC 
		PAYOR 
		PL_NCHS 
		RESIDENT 
		SAMEDAYEVENT 
		TOTCHG 
		YEAR 
		ZIPINC_QRTL 
		INDEX_EVENT
		DISCHARGE_DATE 
		READMIT
		CHARLSON
		MINIMALLY_INVASIVE
		ROBOT_ASSISTED
		OBSTRUCTION 
		CDIFF 
		SEPSIS 
		BACTEREMIA 
		POSTOP_INFECTION
		UTI
		URINARY_CATHETER_INFECTION 
		PYELONEPHRITIS 
		URINARY_COMPLICATION_NOS
		ABCESS
		WOUND_COMPLICATIONS
		SEROMA 
		CENTRAL_CATHETER_INFECTION
		FOREIGN_BODY_OR_OTHER_NOS_COMPLICATION
		URETERAL_URETHRAL_STRICTURE
		STOMA_COMPLICATION
		DVT
		PULMONARY_EMBOLISM
		MYOCARDIAL_INFARCTION_CAD_COMPLICATION
		HEMORRHAGE_OR_ACCIDENTAL_LACERATION
		PNEUMONIA_PNEUMOTHORAX;		
		
save  "NRD_2014_Core_Readmit_Narrow.dta", replace;
append using NRD_2014_Hospital ;



/* Add hospital dummy records */
/* Merges the trimmed version of core file with the hospital file */
/* then saves a merged file "NRD_2014_Core_readmit_trimmed_hospital.dta" */


append using NRD_2014_Hospital;
use "NRD_2014_Core_Readmit_Narrow.dta", clear; 
merge m:1 HOSP_NRD using "NRD_2014_Hospital.dta"; drop _merge;
drop if INDEX_EVENT==0;
save "NRD_2014_Core_Readmit_Narrow_Hosp.dta", replace;

 

/* Severity File */
#delimit ;
import delimited "NRD_2014_Severity.CSV", clear;

rename v1   APRDRG;
rename v2   APRDRD_RISK_MORTALITY;
rename v3   APRDRG_SEVERITY;
rename v4   CM_AIDS;
rename v5   CM_ALCOHOL;
rename v6   CM_ANEMDEF;
rename v7   CM_ARTH;
rename v8   CM_BLDLOSS;
rename v9   CM_CHF;
rename v10  CM_CHRNLUNG;
rename v11  CM_COAG;
rename v12  CM_DEPRESS;
rename v13  CM_DN;
rename v14  CM_DM_CX;
rename v15  CM_DRUG;
rename v16  CM_HTN_C;
rename v17  CM_HYPOTHY;
rename v18  CM_LIVER;
rename v19  CM_LYMPH;
rename v20  CM_LYTES;
rename v21  CM_METS;
rename v22  CM_NEURO;
rename v23  CM_OBESE;
rename v24  CM_PARA;
rename v25  CM_PERIVASC;
rename v26  CM_PSYCH;
rename v27  CM_PULMCIRC;
rename v28  CM_RENLFAIL;
rename v29  CM_TUMOR;
rename v30  CM_ULCER;
rename v31  CM_VALVE;
rename v32  CM_WGHTLOSS;
rename v33  HOSP_NRD;
rename v34  KEY_NRD;


/*  Assign labels to the data elements */
label var APRDRG                   "All Patient Refined DRG" ;
label var APRDRD_RISK_MORTALITY    "All Patient Refined DRG: Risk of Mortality Subclass" ;
label var APRDRG_SEVERITY          "All Patient Refined DRG: Severity of Illness Subclass" ;
label var CM_AIDS                  "AHRQ comorbidity measure: Acquired immune deficiency syndrome" ;
label var CM_ALCOHOL               "AHRQ comorbidity measure: Alcohol abuse" ;
label var CM_ANEMDEF               "AHRQ comorbidity measure: Deficiency anemias" ;
label var CM_ARTH                  "AHRQ comorbidity measure: Rheumatoid arthritis/collagen vascular diseases" ;
label var CM_BLDLOSS               "AHRQ comorbidity measure: Chronic blood loss anemia" ;
label var CM_CHF                   "AHRQ comorbidity measure: Congestive heart failure" ;
label var CM_CHRNLUNG              "AHRQ comorbidity measure: Chronic pulmonary disease" ;
label var CM_COAG                  "AHRQ comorbidity measure: Coagulopathy" ;
label var CM_DEPRESS               "AHRQ comorbidity measure: Depression" ;
label var CM_DM                    "AHRQ comorbidity measure: Diabetes, uncomplicated" ;
label var CM_DM_CX                  "AHRQ comorbidity measure: Diabetes with chronic complications" ;
label var CM_DRUG                  "AHRQ comorbidity measure: Drug abuse" ;
label var CM_HTN_C                 "AHRQ comorbidity measure: Hypertension (combine uncomplicated and complicated)" ;
label var CM_HYPOTHY               "AHRQ comorbidity measure: Hypothyroidism" ;
label var CM_LIVER                 "AHRQ comorbidity measure: Liver disease" ;
label var CM_LYMPH                 "AHRQ comorbidity measure: Lymphoma" ;
label var CM_LYTES                 "AHRQ comorbidity measure: Fluid and electrolyte disorders" ;
label var CM_METS                  "AHRQ comorbidity measure: Metastatic cancer" ;
label var CM_NEURO                 "AHRQ comorbidity measure: Other neurological disorders" ;
label var CM_OBESE                 "AHRQ comorbidity measure: Obesity" ;
label var CM_PARA                  "AHRQ comorbidity measure: Paralysis" ;
label var CM_PERIVASC              "AHRQ comorbidity measure: Peripheral vascular disorders" ;
label var CM_PSYCH                 "AHRQ comorbidity measure: Psychoses" ;
label var CM_PULMCIRC              "AHRQ comorbidity measure: Pulmonary circulation disorders" ;
label var CM_RENLFAIL              "AHRQ comorbidity measure: Renal failure" ;
label var CM_TUMOR                 "AHRQ comorbidity measure: Solid tumor without metastasis" ;
label var CM_ULCER                 "AHRQ comorbidity measure: Peptic ulcer disease excluding bleeding" ;
label var CM_VALVE                 "AHRQ comorbidity measure: Valvular disease" ;
label var CM_WGHTLOSS              "AHRQ comorbidity measure: Weight loss" ;
label var HOSP_NRD                 "NRD hospital identifier" ;
label var HOSP_NRD                  "NRD record identifier" ;

/* Convert special values to missing values */
recode APRDRG                    (-999 -888 -666=.) ;
recode APRDRD_RISK_MORTALITY     (-9 -8 -6 -5=.) ;
recode APRDRG_SEVERITY           (-9 -8 -6 -5=.) ;
recode CM_AIDS                   (-9 -8 -6 -5=.) ;
recode CM_ALCOHOL                (-9 -8 -6 -5=.) ;
recode CM_ANEMDEF                (-9 -8 -6 -5=.) ;
recode CM_ARTH                   (-9 -8 -6 -5=.) ;
recode CM_BLDLOSS                (-9 -8 -6 -5=.) ;
recode CM_CHF                    (-9 -8 -6 -5=.) ;
recode CM_CHRNLUNG               (-9 -8 -6 -5=.) ;
recode CM_COAG                   (-9 -8 -6 -5=.) ;
recode CM_DEPRESS                (-9 -8 -6 -5=.) ;
recode CM_DM                     (-9 -8 -6 -5=.) ;
recode CM_DM_CX                   (-9 -8 -6 -5=.) ;
recode CM_DRUG                   (-9 -8 -6 -5=.) ;
recode CM_HTN_C                  (-9 -8 -6 -5=.) ;
recode CM_HYPOTHY                (-9 -8 -6 -5=.) ;
recode CM_LIVER                  (-9 -8 -6 -5=.) ;
recode CM_LYMPH                  (-9 -8 -6 -5=.) ;
recode CM_LYTES                  (-9 -8 -6 -5=.) ;
recode CM_METS                   (-9 -8 -6 -5=.) ;
recode CM_NEURO                  (-9 -8 -6 -5=.) ;
recode CM_OBESE                  (-9 -8 -6 -5=.) ;
recode CM_PARA                   (-9 -8 -6 -5=.) ;
recode CM_PERIVASC               (-9 -8 -6 -5=.) ;
recode CM_PSYCH                  (-9 -8 -6 -5=.) ;
recode CM_PULMCIRC               (-9 -8 -6 -5=.) ;
recode CM_RENLFAIL               (-9 -8 -6 -5=.) ;
recode CM_TUMOR                  (-9 -8 -6 -5=.) ;
recode CM_ULCER                  (-9 -8 -6 -5=.) ;
recode CM_VALVE                  (-9 -8 -6 -5=.) ;
recode CM_WGHTLOSS               (-9 -8 -6 -5=.) ;
recode HOSP_NRD                  (-9999 -8888 -6666=.) ;
recode HOSP_NRD                   (-99999999999999 -88888888888888 -66666666666666=.) ;

merge 1:1 KEY_NRD HOSP_NRD using "NRD_2014_Core_Readmit_Narrow_Hosp.dta"; 
drop if _merge!=3;
drop _merge;
save "NRD_2014_Core_Readmit_Narrow_Hosp_Severity.dta", replace;

 
 
