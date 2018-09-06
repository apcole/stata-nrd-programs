/*File to just plot hospital-level readmission rates with 95% CI for each HOSP_NRD*/

/*Import Data*/
# delimit; 
cd "/NRD_RC_Predictors/Data";
use "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity.dta", replace; 

/*Assign survey weights*/
svyset HOSP_NRD [pw=DISCWT], singleunit(cen) strata(NRD_STRATUM);

/*Weighted sample sizes and exclusion criteria*/
svy:tab READMIT, count se;

/*Number to be excluded due to benign or non bladder CA*/
svy:tab INDEX_DX, count se;

/* Drops if not bladder cancer e.g. benign indication, gyn primary, etc */
drop if INDEX_DX!=1;

/*Number to be excluded due to out of state resident*/
svy:tab RESIDENT, count se;

/*Drops if patient is resident of a different state than where surgery was performed */
drop if RESIDENT==0;

/*Need to generate CASELOAD variable*/
sort HOSP_NRD;
quietly by HOSP_NRD:  generate CASELOAD=_N;

drop if CASELOAD==1;

/*Generate hospital readmit rate*/
bysort HOSP_NRD: egen hosp_readmit_rate = mean(READMIT);

summarize hosp_readmit_rate, detail;

by hosp_readmit_rate, sort: gen nvals_hosp_readmit_rate= _n == 1 ;
count if nvals_hosp_readmit_rate==1 ;

bysort HOSP_NRD: egen sd_hosp_readmit = sd(READMIT);

by sd_hosp_readmit, sort: gen nvals_sd_hosp_readmit= _n == 1 ;
count if nvals_sd_hosp_readmit==1 ;


gen se_mean= sd_hosp_readmit/sqrt(CASELOAD);

gen lower_ci=hosp_readmit_rate-1.96*se_mean;
gen upper_ci=hosp_readmit_rate+1.96*se_mean;

drop if CASELOAD<=10;

collapse  
	hosp_readmit_rate
	lower_ci
	upper_ci,	
		by(HOSP_NRD);

	by hosp_readmit_rate, sort: gen nvals_hosp_readmit_rate= _n == 1 ;
count if nvals_hosp_readmit_rate==1 ;

		
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

