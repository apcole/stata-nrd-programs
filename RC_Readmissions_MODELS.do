/*Import Data*/
# delimit; 
#set more off;
cd "/Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD_RC_Predictors/Data";
use "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity.dta", replace; 
set more off;

/*Assign survey weights, and standard error of readmission rates*/
svyset HOSP_NRD [pw=DISCWT], singleunit(cen) strata(NRD_STRATUM);

/*Apply Exclusion Criteria and Save as "NRD_2014_Core_Excluded.dta"*/

	/*Number to be excluded due to benign or non bladder CA*/
	svy:tab INDEX_DX, count se;

	/* Drops if not bladder cancer e.g. benign indication, gyn primary, etc */
	drop if INDEX_DX!=1;

	/*Number to be excluded due to out of state resident*/
	svy:tab RESIDENT, count se;

	/*Drops if patient is resident of a different state than where surgery was performed */
	drop if RESIDENT==0;
	
	/*Number to be excluded due to non elective*/
	svy:tab ELECTIVE, count se;
	
	/*Drops if non elective */
	drop if ELECTIVE!=1;

	/*Need to generate CASELOAD variable*/
	sort HOSP_NRD;
	quietly by HOSP_NRD:  generate CASELOAD=_N;
	
	/*Number to be excluded due to non elective*/
	gen SINGLE=1 if CASELOAD==1;
	svy:tab SINGLE, count se;
	
	/*Drops if single case at hospital */
	drop if SINGLE==1;

	/*Weighted sample sizes, SE after exclusion criteria*/
	svy:tab READMIT, count se;

	/*Number of hospitals after exclusion criteria*/	
	by HOSP_NRD, sort: gen nvals = _n == 1;
	count if nvals==1;
	drop nvals;

	/*Save excluded Data*/
	save "NRD_2014_Core_Excluded.dta", replace;
	
/*Generate quartiles (of hospitals) using previously generated caseload variable*/
use "NRD_2014_Core_Excluded.dta", replace;
collapse (sum) CASELOAD, by (HOSP_NRD);
xtile CASELOAD_QUART=CASELOAD, nquantiles(4);
label define CASELOAD_QUART 
	1 "1st quartile" 
	2 "2nd quartile" 
	3 "3rd quartile" 
	4 "4th quartile";
label values CASELOAD_QUART CASELOAD_QUART;
la var CASELOAD "Caseload at HOSP_NRD per year"; 
la var CASELOAD_QUART " Quartile of volume of HOSP_NRD (after Excluding caseload=1)";
keep CASELOAD CASELOAD_QUART HOSP_NRD;

gen HIGH_VOLUME=0;
replace HIGH_VOLUME=1 if CASELOAD_QUART==10;

save "Caseload.dta", replace;
use "NRD_2014_Core_Excluded.dta", clear;
merge m:1 HOSP_NRD using "Caseload.dta";
drop _merge; 
save "NRD_2014_Core_Excluded.dta", replace;
rm "Caseload.dta";

/*Mean caseload*/
summarize CASELOAD if CASELOAD_QUART==1, detail;
summarize CASELOAD if CASELOAD_QUART==2, detail;
summarize CASELOAD if CASELOAD_QUART==3, detail;
summarize CASELOAD if CASELOAD_QUART==4, detail;

/*Generation of READMIT_NUMBER variable*/
collapse (sum) READMIT, by (HOSP_NRD);
rename READMIT READMIT_NUMBER;
la var READMIT_NUMBER "Number of readmissions in year at HOSP_NRD";
keep READMIT_NUMBER HOSP_NRD;
save "Readmissions.dta", replace;
use "NRD_2014_Core_Excluded.dta", clear;
merge m:1 HOSP_NRD using "Readmissions.dta";
drop _merge;
rm "Readmissions.dta";
describe;

/* Create READMIT_RATE, CCI_CAT*/
gen READMIT_RATE=READMIT_NUMBER/CASELOAD;

/* Create CCI_CAT*/
recode CHARLSON
	(0=0 "CCI 0")
	(1=1 "CCI 1")
	(2/8=2 "CCI 2+")
	(else=.),
	gen(CCI_CAT);

/*Generate quartiles of costs (of hospitals) using previously generated Cose*/
xtile COST_QUART=INDEX_COSTS, nquantiles(4);
label define COST_QUART 
	1 "1st quartile" 
	2 "2nd quartile" 
	3 "3rd quartile" 
	4 "4th quartile";
label values COST_QUART COST_QUART;
la var COST_QUART " Quartile of volume of HOSP_NRD (after Excluding caseload=1)";

summarize INDEX_COSTS if COST_QUART==1, detail;
summarize INDEX_COSTS if COST_QUART==2, detail;
summarize INDEX_COSTS if COST_QUART==3, detail;
summarize INDEX_COSTS if COST_QUART==4, detail;


/*Baseline characteristics */	
svyset HOSP_NRD [pw=DISCWT], singleunit(cen) strata(NRD_STRATUM);

***> Regular crosstabs to get the frequencies and row percentages, ANOVA for continuous variables
**** Leaving these out for now because HCUP doesn't want regular frequencies in the tables. 

*/oneway AGE READMIT, means freq;
*/tab AGE_CAT READMIT, col chi;
*/tab FEMALE READMIT, col chi;
*/tab CCI_CAT READMIT, col chi;
*/tab CASELOAD_QUART READMIT, col chi;
*/tab MINIMALLY_INVASIVE READMIT, col chi;
*/tab PAYOR READMIT, col chi;
*/tab H_CONTROL READMIT, col chi;
*/tab ZIPINC_QRTL READMIT, col chi;
*/tab HOSP_BEDSIZE READMIT, col chi;
*/tab DMONTH READMIT, col chi;
*/oneway LOS READMIT, means freq;
*/oneway INDEX_COSTS READMIT, means freq;

/* National estimates based on NRD design */ 
/* Specify the sampling design with sampling weights DISCWT, */ 
/* hospital clusters HOSP_NRD, and stratification NRD_STRATUM */ 
/* "linearized*: Taylor-linearized variance estimation, see http://www.stata.com/manuals13/svysvy.pdf */
svyset HOSP_NRD [pw=DISCWT], singleunit(cen) strata(NRD_STRATUM);

/* Subset on index events */
svy: total READMIT, subpop(INDEX_EVENT);
svy: mean READMIT, subpop(INDEX_EVENT);

/* Patient-level demographics */
/* Table1 calculations for categorical  variables*/
#delimit cr

/*Readmission rates */
svy:tab READMIT, count se
svy linearized: mean READMIT

/* Sex breakdown of weighted cohorts*/
svy linearized: tab FEMALE READMIT, col pearson

/* AGE cat */
svy linearized: tab AGE_CAT READMIT, col pearson


/* CCI cat */
svy linearized: tab CCI_CAT READMIT, col pearson

/* Volume cat*/
svy linearized: tab CASELOAD_QUART READMIT, col pearson

/* Minimally invasive*/
svy linearize: tab MINIMALLY_INVASIVE READMIT, col pearson

/* Payor*/
svy linearized: tab PAYOR READMIT, col pearson

/* Hospital ownership*/
svy linearized: tab H_CONTROL READMIT, col pearson

/* Income*/
svy linearized: tab ZIPINC_QRTL READMIT, col pearson

/* Bedsize*/
svy linearized: tab HOSP_BEDSIZE READMIT, col pearson

/* Month of hospitalization*/
svy linearized: tab DMONTH READMIT, col pearson

/*Table1 calculations for continuous variables */
#delimit ;

/* Mean age of weighted cohorts*/
svy linearized: mean AGE;
svy linearized: mean AGE, over(READMIT);
test [AGE]1 - [AGE]0 = 0;

/* Mean LOS  weighted cohorts*/
svy linearized: mean LOS;
svy linearized: mean LOS, over(READMIT);
test [LOS]1 - [LOS]0 = 0;

/* Mean COSTS of weighted cohorts*/
svy linearized: mean INDEX_COSTS;
svy linearized: mean INDEX_COSTS, over(READMIT);
test [INDEX_COSTS]1 - [INDEX_COSTS]0 = 0;

/* Median CASELOAD in each of the four quartiles*/
summarize CASELOAD if CASELOAD_QUART==1, detail;
summarize CASELOAD if CASELOAD_QUART==2, detail;
summarize CASELOAD if CASELOAD_QUART==3, detail;
summarize CASELOAD if CASELOAD_QUART==4, detail;

/* Mean CASELOAD of weighted cohorts*/
svy linearized: mean CASELOAD;
svy linearized: mean CASELOAD, over(CASELOAD_QUART);

/* CASELOAD QUARTILE of weighted cohorts */
svy linearized: tab CASELOAD_QUART READMIT, row pearson;

/*Save the cohort immediately before the model to be used for calculating Pseudo R Squared*/
save "ModelCohort.dta", replace;

/* multilevel model with a random effects variable for HOSP_NRD
xtmelogit READMIT 
	c.AGE 
	FEMALE 
	i.CCI_CAT 
	i.CASELOAD_QUART 
	i.MINIMALLY_INVASIVE 
	i.PAYOR i.H_CONTROL 
	i.ZIPINC_QRTL 
	i.HOSP_BEDSIZE 
	i.DMONTH 
	c.LOS
	c.INDEX_COSTS, or || HOSP_NRD: , intpoints(20) */

/* MLM with only patient variables*/
#delimit;
xtmelogit READMIT 
	i.AGE_CAT 
	FEMALE 
	i.CCI_CAT 
	ib0.PAYOR 
	i.ZIPINC_QRTL, or || HOSP_NRD:, covariance(exchangeable) intpoints(100); 

/*
/* Models for comparing log likelihood, full R squared is model just withe READMIT*/

/*Null model (only intercept), full model is above*/
logit READMIT 

/*Model without patient characteristics */
xtmelogit READMIT i.CASELOAD_QUART i.MINIMALLY_INVASIVE  i.H_CONTROL i.HOSP_BEDSIZE  i.DMONTH c.LOS c.INDEX_COSTS, or || HOSP_NRD: , intpoints(20) 


/*Model without hospital characteristics*/
xtmelogit READMIT c.AGE FEMALE i.CCI_CAT  i.MINIMALLY_INVASIVE i.PAYOR i.ZIPINC_QRTL  i.DMONTH c.LOS c.INDEX_COSTS, or || HOSP_NRD: , intpoints(20) 

/*Model without hospitalization characteristics*/
xtmelogit READMIT c.AGE FEMALE i.CCI_CAT i.CASELOAD_QUART  i.PAYOR i.H_CONTROL i.ZIPINC_QRTL i.HOSP_BEDSIZE, or || HOSP_NRD: , intpoints(20) 

/*Model without random effects*/
logit  READMIT c.AGE FEMALE i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR i.H_CONTROL i.ZIPINC_QRTL i.HOSP_BEDSIZE  i.DMONTH c.LOS c.INDEX_COSTS, or

/*Model with ONLY random effects*/
xtmelogit  READMIT, or || HOSP_NRD: , intpoints(10) 

*/
	/*

	/***> Calculation of chi square values for partial R-square calculations (To calculate R-square use Excel-Calculator)*/
	/* Patient-level socioeconomic demographics// combined patient level variables*/
	testparm c.AGE FEMALE i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR i.H_CONTROL i.ZIPINC_QRTL i.HOSP_BEDSIZE i.DMONTH c.LOS c.INDEX_COSTS 
	/* Single patient-level variables*/
	testparm i.AGE_CAT
	testparm FEMALE 
	testparm i.CCI_CAT 
	testparm i.PAYOR
	testparm i.ZIPINC_QRTL 
	testparm i.MINIMALLY_INVASIVE 

	/* Combined hospital level variables**/
	testparm i.H_CONTROL i.HOSP_BEDSIZE i.CASELOAD_QUART 
	/** Single hospital level variables**/
	testparm i.H_CONTROL
	testparm i.HOSP_BEDSIZE
	testparm i.CASELOAD_QUART

	*/

#delimit cr
/*Linear predictor for the RANDOM effects*/
predict re*, reffects 
	describe re1
	sum re1, detail

	/*Check number of unique values for REs*/
		by re1, sort: gen nvals_re1 = _n == 1 
		count if nvals_re1==1

			/*Calculate standard errors for re*/
			predict se*, reses
				describe se1
				sum se1, detail
					
				/*Check number of unique values for SEs*/
					by se1, sort: gen nvals_se1 = _n == 1 
					count if nvals_se1==1

/*Linear predictor for the FIXED effects*/
predict xb, xb 
	describe xb
	sum xb, detail

	/*Check number of unique values for fixed effects*/
		by xb, sort: gen nvals_xb1 = _n == 1 
		count if nvals_xb1==1

/*Predicted mean including BOTH FIXED and RANDOM. 
	By default, this is based on a linear predictor that includes 
	both the fixed effects and the random effects, and the 
	predicted mean is conditional on the values of the random effects.
	http://www.stata-press.com/manuals/errata/stata12/i/xtmelogit_postestimation.pdf*/

predict mu, mu
	describe mu
	sum mu, detail
	tabstat mu, by(READMIT)
	
	
predict xb_se, stdp
	describe xb_se
	sum xb_se, detail
	tabstat xb_se, by(READMIT)

/*Predicted mean probability from mixed-effects model by each facility*/
	bysort HOSP_NRD: egen meanmufac = mean (mu)

*****> Counts number of unique values of meanmufac which is the facility-level probability of readmission. 
by meanmufac, sort: gen nvals_meanmufac = _n == 1 
count if nvals_meanmufac==1

**> Predicted mean probability from mixed-effects model overall
egen meanmu = mean (mu)
tab meanmu

by meanmu, sort: gen nvals_meanmu = _n == 1 
count if nvals_meanmu==1

*> (1) Analyses using "meanmu", which should be predicted mean probability from mixed-effects models...adding the Re1 to the log transformed meanmu?
gen logitmeanmu=log(meanmu/(1-meanmu))
gen mu_pred_readmit=exp(logitmeanmu+re1)/(1+exp(logitmeanmu+re1))
sum mu_pred_readmit, detail


by mu_pred_readmit , sort: gen nvals_mu_pred_readmit = _n == 1 
count if nvals_mu_pred_readmit==1


bysort HOSP_NRD: egen mu_pred_readmit_fac=mean(mu_pred_readmit)


by mu_pred_readmit_fac , sort: gen nvals_mu_pred_readmit_fac = _n == 1 
count if nvals_mu_pred_readmit_fac==1


*> Generate lower and upper confidence intervals for preread (Dr. Lipsitz)
gen mu_log_lowerci=logitmeanmu+re1-1.96*se1
gen mu_log_upperci=logitmeanmu+re1+1.96*se1

gen lowerbound_mu_pred_readmit=exp(mu_log_lowerci)/(1+exp(mu_log_lowerci))
bysort HOSP_NRD: egen lowerbound_mu_pred_readmit_fac=mean(lowerbound_mu_pred_readmit)

gen upperbound_mu_pred_readmit=exp(mu_log_upperci)/(1+exp(mu_log_upperci))
bysort HOSP_NRD: egen upperbound_mu_pred_readmit_fac=mean(upperbound_mu_pred_readmit)

by lowerbound_mu_pred_readmit, sort: gen nvals_lowerpredread= _n == 1 
count if nvals_lowerpredread==1
by lowerbound_mu_pred_readmit_fac, sort: gen nvals_lowerpredread_fac= _n == 1 
count if nvals_lowerpredread_fac==1

save "NRD_2014_Core_Excluded_Predicted_Rates.dta", replace



/* STOP HERE AND MOVE TO THE CATEPILLAR PLOTS ***/






/*




**> Then use "lowermeanpreread" and "uppermeanpreread" for collapsing command (rank meanpreread after collapsing)
egen rank_mu_pred_readmit_fac=rank(mu_pred_readmit_fac)

#delimit;
collapse  
	mu_pred_readmit_fac
	lowerbound_mu_pred_readmit_fac
	upperbound_mu_pred_readmit_fac,	
		by(HOSP_NRD);
		
	egen rank_mu_pred_readmit_fac=rank(mu_pred_readmit_fac);
	drop if mu_pred_readmit_fac==.;
		
#delimit;		
twoway 
	(scatter mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs1) )
	(scatter lowerbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs10) )
	(scatter upperbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs10)), 
	legend(off)
	graphregion(color(white)) 
	bgcolor(white) 
	title("Figure 1: Adjusted  Probabilities of Readmission" 
		  "Based on Facility-level Random Effects Term" 
		  "with 95% Confidence Intervals"
		  " ", 
		  span color(black) size(4))  
	yla(0 "0" 0.10 "10"  0.20 "20" 0.30 "30" 0.40 "40" 0.5 "50" ) ytitle("Probability of Readmission, (%)" " ")
	xtitle("Hospital Rank" "(least to greatest adjusted probability of readmission)");
	#delimit cr

#delimit;		
twoway 
	(scatter mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs1) )
	(scatter lowerbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs10) )
	(scatter upperbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs10)), 
	legend(off)
	graphregion(color(white)) 
	bgcolor(white) 
	title("Figure 1: Adjusted  Probabilities of Readmission" 
		  "Based on Facility-level Random Effects Term" 
		  "with 95% Confidence Intervals"
		  " ", 
		  span color(black) size(4))  
	yla(0.20 "20" 0.22 "22" 0.24 "24" 0.26 "26" 0.28 "28" 0.30 "30" ) ytitle("Probability of Readmission, (%)" " ")
	xtitle("Hospital Rank" "(least to greatest adjusted probability of readmission)");
	#delimit cr

	








*********
****** OR
*********

*> Mean overall readmission rate (unadjusted??)
egen meanreadmit_rate=mean(READMIT)

tab meanreadmit

twoway (scatter meanreadmit HOSP_NRD) (scatter READMIT HOSP_NRD)


*> (2) Analyses using "pred_readmit", which should be unadjusted (?) mean readmission rate (?) in overall population
gen logitmeanreadmit=log(meanreadmit/(1-meanreadmit))
gen pred_readmit=exp(logitmeanreadmit+re1)/(1+exp(logitmeanreadmit+re1))
sum pred_readmit, detail

bysort HOSP_NRD: egen pred_readmit_fac=mean(pred_readmit)


*> Generate lower and upper confidence intervals for preread2 (Dr. Lipsitz)
gen read_loglowerci=logitmeanreadmit+re1-1.96*se1
gen read_logupperci=logitmeanreadmit+re1+1.96*se1

gen lowerbound_read_pred_readmit=exp(read_loglowerci)/(1+exp(read_loglowerci))
bysort HOSP_NRD: egen lowerbound_read_pred_readmit_fac=mean(lowerbound_read_pred_readmit)
gen upperbound_read_pred_readmit=exp(read_logupperci)/(1+exp(read_logupperci))
bysort HOSP_NRD: egen upperbound_read_pred_readmit_fac=mean(upperbound_read_pred_readmit)


save "BladderPostmixes1.dta", replace

************************************************************************************************************************
*** Create new dataset to collapse variables if interest (for figures) by facilityid, and to get facility-level dots ***
************************************************************************************************************************

use "BladderPostmixes1.dta", clear

#delimit;
collapse  
	AGE 
	SEX 
	CCI_CAT 
	CASELOAD_QUART 
	MINIMALLY_INVASIVE 
	PAYOR H_CONTROL 
	ZIPINC_QRTL 
	HOSP_BEDSIZE 
	DMONTH 
	LOS 
	INDEX_COSTS
	mu_pred_readmit_fac
	lowerbound_mu_pred_readmit_fac
	upperbound_mu_pred_readmit_fac,	
		by(HOSP_NRD);
		
#delimit cr


***> Rank everything NOW, because then it will be facility-level.

egen rankpreread_mu=rank(mu_pred_readmit_fac)
egen rankmeanpreread_read=rank(pred_readmit_fac)


**********************
*** Create figures ***
**********************

twoway scatter meanpreread2 rankmeanpreread2 || lowermeanpreread2 rankmeanpreread2
twoway scatter meanpreread rankmeanpreread || lowermeanpreread rankmeanpreread

histobox meanpreread2 
scatter preread meancaseload || lfit preread meancaseload

graph box meanpreread2, over(CCI_CAT)


twoway (scatter meanpreread2 rankmeanpreread2)(scatter lowermeanpreread2 rankmeanpreread2)(scatter uppermeanpreread2 rankmeanpreread2)
twoway (scatter meanpreread rankmeanpreread)(scatter lowermeanpreread rankmeanpreread)(scatter uppermeanpreread rankmeanpreread)



twoway rcap lowermeanpreread uppermeanpreread rankmeanpreread || scatter meanpreread rankmeanpreread, legend(label(1 "faci") Label(2 "bet)"

twoway rcap lowermeanpreread uppermeanpreread rankmeanpreread || scatter meanpreread rankmeanpreread, ytitle("Mean probability (%)") xtitle("Commission on Cancer-Accredited Facilities (N = 1,139)") xlabel(0(100)1200) legend(order(2 "Facility-level adjusted mean probabilities of unplanned 30-day readmission rates (based on mixed-effects hierarchical logistic regression model)" )) legend(size(tiny))











/*BELOW HERE JUST PLAYING AROUND*/

by meanmufac, sort: gen nvals = _n == 1 



logit READMIT i.ROBOT_ASSISTED i.CCI_CAT, or

tab ORPROC


logit READMIT c.CASELOAD



#delimit;
recode CHARLSON
	(4=4 "CCI 4")
	(5=5 "CCI 5")
	(6=6 "CCI 6")
	(7=7 "CCI 7")
	(8=8 "CCI 8")
	(9/14=9 "CCI 9+")
	(else=.),
	gen(CCI_CAT);

logit READMIT i.CCI_CAT, or	
	
logit READMIT i.PAY1, or	

logit READMIT c.CASELOAD

anova READMIT_RATE CASELOAD, o

logit READMIT c.CASELOAD

logit READMIT i.AGE_CAT i.CCI_CAT i.PAYOR  i.ROBOT_ASSISTED i.H_CONTROL i.HOSP_BEDSIZE i.CASELOAD_QUART c.LOS, or
logit READMIT i.AGE_CAT i.CHARLSON i.PAY1 i.RESIDENT i.H_CONTROL i.HOSP_BEDSIZE i.CASELOAD_QUART c.READMIT_RATE c.LOS, or;

graph box READMIT_RATE, by(READMIT);

twoway (scatter READMIT READMIT_RATE ) ;




separate READMIT_RATE, by(HOSP_UR_TEACH)
twoway (scatter READMIT_RATE0 CASELOAD) (scatter READMIT_RATE1 CASELOAD) 


  ytitle(Writing Score) legend(order(1 "Males" 2 "Females"))

  
  */

  
  

  
  
  
  
  
  
  
  
