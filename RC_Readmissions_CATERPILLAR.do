/*File to just plot hospital-level readmission rates with 95% CI for each HOSP_NRD*/

# delimit; 
cd "/Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD_RC_Predictors/Data";
use "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity.dta", replace; 


/*Generation of volume variables */
/* Create variable CASELOAD for HOSP_NRD, and collapse so it equals hosp */
gen CASELOAD=1;
collapse (sum) CASELOAD, by (HOSP_NRD);
xtile CASELOAD_QUART=CASELOAD, nquantiles(4);
label define CASELOAD_QUART 
	1 "1st quartile" 
	2 "2nd quartile" 
	3 "3rd quartile" 
	4 "4th quartile";
label values CASELOAD_QUART CASELOAD_QUART;
la var CASELOAD "Caseload at HOSP_NRD per year"; 
la var CASELOAD_QUART "Quartile of volume of HOSP_NRD";
keep CASELOAD CASELOAD_QUART HOSP_NRD;
save "Caseload.dta", replace;
use "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity.dta", clear;
merge m:1 HOSP_NRD using "Caseload.dta";
drop _merge; 
save "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity_C.dta", replace; 
rm "Caseload.dta";
describe;

/*Generation of READMIT_NUMBER variable*/
/* Create "READMIT_NUMBER" variable for HOSP_NRD */
collapse (sum) READMIT, by (HOSP_NRD);
rename READMIT READMIT_NUMBER;
la var READMIT_NUMBER "Number of readmissions in year at HOSP_NRD";
keep READMIT_NUMBER HOSP_NRD;
save "Readmissions.dta", replace;
use "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity_C.dta", clear;
merge m:1 HOSP_NRD using "Readmissions.dta";
rm "Readmissions.dta";
rm "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity_C.dta";
drop _merge; 
describe;

/* Create variable READMIT_RATE, CCI_CAT, CASELOAD_QART and drop if non-resident */
#delimit;
gen READMIT_RATE=READMIT_NUMBER/CASELOAD;

recode CHARLSON
	(4=4 "CCI 4")
	(5=5 "CCI 5")
	(6=6 "CCI 6")
	(7=7 "CCI 7")
	(8=8 "CCI 8")
	(9/14=9 "CCI 9+")
	(else=.),
	gen(CCI_CAT);
xtile CASELOAD_20=CASELOAD, nquantiles(20);

/* Keeps only those with INDEX_DX as defined in the LOADER file, e.g. only RC patients with bladder CA */
keep if INDEX_DX==1;
/* drops if patient is resident ot a different state than where surgery was performed */
drop if RESIDENT==0;

#delimit;


gen mean_readmit_rate=sum(READMIT)/CASELOAD;
by re1, sort: gen nvals_re1 = _n == 1 
count if nvals_re1==1


