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

bysort HOSP_NRD: egen hosp_readmit_rate = mean(READMIT);

by hosp_readmit_rate, sort: gen nvals_hosp_readmit_rate= _n == 1 ;
count if nvals_hosp_readmit_rate==1 ;


bysort HOSP_NRD: egen sd_hosp_readmit = sd(READMIT);

by sd_hosp_readmit, sort: gen nvals_sd_hosp_readmit= _n == 1 ;
count if nvals_sd_hosp_readmit==1 ;


gen se_mean= sd_hosp_readmit/sqrt(CASELOAD);

gen lower_ci=hosp_readmit_rate-1.96*se_mean;
gen upper_ci=hosp_readmit_rate+1.96*se_mean;


#delimit;
collapse  
	AGE 
	SEX 
	CCI_CAT 
	CASELOAD
	CASELOAD_QUART 
	MINIMALLY_INVASIVE 
	PAYOR H_CONTROL 
	ZIPINC_QRTL 
	HOSP_BEDSIZE 
	DMONTH 
	LOS 
	INDEX_COSTS
	hosp_readmit_rate
	lower_ci
	upper_ci,	
		by(HOSP_NRD);

	by hosp_readmit_rate, sort: gen nvals_hosp_readmit_rate= _n == 1 ;
count if nvals_hosp_readmit_rate==1 ;


	drop if CASELOAD<=10;
	
		
	egen rank_readmit_fac=rank(hosp_readmit_rate);
	drop if hosp_readmit_rate==.;
	

#delimit;		
twoway 
	(scatter lower_ci rank_readmit_fac, msymbol(circle) mcolor(gs10) )
	(scatter upper_ci rank_readmit_fac, msymbol(circle) mcolor(gs10))
	(scatter hosp_readmit_rate rank_readmit_fac, msymbol(circle) mcolor(gs1)), 
	legend(off)
	graphregion(color(white)) 
	bgcolor(white) 
	title("Figure 1: Hospital Level  Readmission Rates"
		  "with 95% Confidence Intervals"
		  " ", 
		  span color(black) size(4))  
	yla(0 "0" 0.10 "10"  0.20 "20" 0.30 "30" 0.40 "40" 0.5 "50" 0.6 "60" 0.7 "70" 0.8 "80") ytitle("Probability of Readmission, (%)" " ")
	xtitle("Hospital Rank" "(least to greatest readmission rate)");
	#delimit cr


	

mean(READMIT), over(HOSP_NRD);

by READMIT_NUMBER, sort: gen nvals_READMIT_NUMBER = _n == 1 ;
count if nvals_READMIT_NUMBER==1 ;

gen mean_readmit_rate=(READMIT_NUMBER)/CASELOAD;
by mean_readmit_rate, sort: gen nvals_mean_readmit_rate = _n == 1 ;
count if nvals_mean_readmit_rate==1 ;


