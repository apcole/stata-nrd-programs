# delimit; 
cd "/Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD_RC_Predictors/Data";
use "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity.dta", replace; 

/* Keeps only those with INDEX_DX as defined in the LOADER file, e.g. only RC patients with bladder CA */
keep if INDEX_DX==1;
/* drops if patient is resident ot a different state than where surgery was performed */
drop if RESIDENT==0;

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
	


/* */


/* National estimates based on NRD design */ /* Specify the sampling design with sampling weights DISCWT, */ /* hospital clusters HOSP_NRD, and stratification NRD_STRATUM */ svyset HOSP_NRD [ pw=DISCWT ], strata( NRD_STRATUM ) ;
# delimit;
svyset HOSP_NRD [pw=DISCWT], singleunit(cen) strata(NRD_STRATUM);

/* Subset on index events */
svy: total READMIT, subpop(INDEX_EVENT);
svy: mean READMIT, subpop(INDEX_EVENT);

/* Patient-level demographics */
/* "linearized*: Taylor-linearized variance estimation, see http://www.stata.com/manuals13/svysvy.pdf */
svy linearized: tab AGE_CAT  READMIT, col pearson;

svy linearized: tab SEX READMIT, col pearson;

svy linearized: tab PAYOR READMIT, col pearson;

svy linearized: tab ZIPINC_QRTL READMIT, col pearson;

svy linearized: tab HOSP_URCAT4 READMIT, col pearson;

svy linearized: tab CCI_CAT READMIT, col pearson;

svy linearized: tab CASELOAD_QUART READMIT, col pearson;

#delimit cr

/* multilevel model with a random effects variable for HOSP_NRD*/
xtmelogit READMIT c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR i.H_CONTROL i.ZIPINC_QRTL i.HOSP_BEDSIZE  i.DMONTH c.LOS c.INDEX_COSTS, or || HOSP_NRD: , intpoints(10) 


/* Trial models to determine which ones made the model break*/

*/xtmelogit READMIT, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX i.CCI_CAT, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE , or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR i.H_CONTROL, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR i.H_CONTROL i.ZIPINC_QRTL i.DMONTH, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR i.H_CONTROL i.ZIPINC_QRTL i.HOSP_BEDSIZE i.DMONTH, or || HOSP_NRD: , intpoints(10) 
*/xtmelogit READMIT c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR i.H_CONTROL i.ZIPINC_QRTL i.HOSP_BEDSIZE i.DMONTH c.LOS, or || HOSP_NRD: , intpoints(10) 

/***> Calculation of chi square values for partial R-square calculations (To calculate R-square use Excel-Calculator)*/
/* Patient-level socioeconomic demographics// combined patient level variables*/
testparm c.AGE i.SEX i.CCI_CAT i.CASELOAD_QUART i.MINIMALLY_INVASIVE i.PAYOR i.H_CONTROL i.ZIPINC_QRTL i.HOSP_BEDSIZE i.DMONTH c.LOS c.INDEX_COSTS 
/* Single patient-level variables*/
testparm c.AGE
testparm i.SEX 
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

*********************************************
*** Generate postestimation probabilities ***
*********************************************

***> linear predictor for the random effects

predict re*, reffects 
describe re1
sum re1, detail

***> Calculate standard errors for re*
predict se1*, reses

***> Linear predictor for the fixed effects
predict xb, xb 
describe xb
sum xb, detail


***> Predicted mean including both fixed and random effects. By default, this is based on a linear predictor that includes both the fixed effects and the random effects, and the predicted mean is conditional on the values of the random effects.
// See 	http://www.stata-press.com/manuals/errata/stata12/i/xtmelogit_postestimation.pdf
predict mu, mu
describe mu
sum mu, detail
**> Predicted mean probability from mixed-effects model by each facility
bysort HOSP_NRD: egen meanmufac = mean (mu)

**> Predicted mean probability from mixed-effects model overall
egen meanmu = mean (mu)


******************
*** EXPERIMENT ***
******************

***> Calculate standard errors for re*
predict se2*, reses

*> (1) Analyses using "meanmu", which should be predicted mean probability from mixed-effects models
gen logitmeanmu=log(meanmu/(1-meanmu))
gen preread=exp(logitmeanmu+re1)/(1+exp(logitmeanmu+re1))
sum preread, detail

bysort HOSP_NRD: egen meanpreread=mean(preread)

*> Generate lower and upper confidence intervals for preread (Dr. Lipsitz)
gen lowerci=logitmeanmu+re1-1.96*se1
gen upperci=logitmeanmu+re1+1.96*se1

gen lowerpreread=exp(lowerci)/(1+exp(lowerci))
bysort HOSP_NRD: egen lowermeanpreread=mean(lowerpreread)
gen upperpreread=exp(upperci)/(1+exp(upperci))
bysort HOSP_NRD: egen uppermeanpreread=mean(upperpreread)

**> Then use "lowermeanpreread" and "uppermeanpreread" for collapsing command (rank meanpreread after collapsing)
egen rankmeanpreread=rank(meanpreread)
twoway (scatter meanpreread rankmeanpreread)(scatter lowermeanpreread rankmeanpreread)(scatter uppermeanpreread rankmeanpreread)




*********
****** OR
*********

*> Mean overall readmission rate (unadjusted??)
egen meanread=mean(READMIT)

*> (2) Analyses using "meanread", which should be unadjusted (?) mean readmission rate (?) in overall population
gen logitmeanread=log(meanread/(1-meanread))
gen preread2=exp(logitmeanread+re1)/(1+exp(logitmeanread+re1))
sum preread2, detail
bysort HOSP_NRD: egen meanpreread2=mean(preread2)


*> Generate lower and upper confidence intervals for preread2 (Dr. Lipsitz)
gen lowerci2=logitmeanread+re1-1.96*se1
gen upperci2=logitmeanread+re1+1.96*se1

gen lowerpreread2=exp(lowerci2)/(1+exp(lowerci2))
bysort HOSP_NRD: egen lowermeanpreread2=mean(lowerpreread2)
gen upperpreread2=exp(upperci2)/(1+exp(upperci2))
bysort HOSP_NRD: egen uppermeanpreread2=mean(upperpreread2)


save "BladderPostmixes1.dta", replace

************************************************************************************************************************
*** Create new dataset to collapse variables if interest (for figures) by facilityid, and to get facility-level dots ***
************************************************************************************************************************

use "BladderPostmixes1.dta", clear

collapse meanpreread2 lowermeanpreread2 uppermeanpreread2 mu meanmu AGE SEX CCI_CAT CASELOAD_QUART MINIMALLY_INVASIVE PAYOR H_CONTROL ZIPINC_QRTL HOSP_BEDSIZE DMONTH LOS INDEX_COSTS , by(HOSP_NRD)

***> Rank everything NOW, because then it will be facility-level.

egen rankmeanpreread=rank(meanpreread)
egen rankmeanpreread2=rank(meanpreread2)


**********************
*** Create figures ***
**********************

scatter meanpreread2 rankmeanpreread2 || lowermeanpreread2 rankmeanpreread2
scatter meanpreread rankmeanpreread || lowermeanpreread rankmeanpreread

histobox meanpreread2 
scatter preread meancaseload || lfit preread meancaseload

graph box meanpreread2, over(CCI_CAT)


twoway (scatter meanpreread2 rankmeanpreread2)(scatter lowermeanpreread2 rankmeanpreread2)(scatter uppermeanpreread2 rankmeanpreread2)
twoway (scatter meanpreread rankmeanpreread)(scatter lowermeanpreread rankmeanpreread)(scatter uppermeanpreread rankmeanpreread)



twoway rcap lowermeanpreread uppermeanpreread rankmeanpreread || scatter meanpreread rankmeanpreread, legend(label(1 "faci") Label(2 "bet)"

twoway rcap lowermeanpreread uppermeanpreread rankmeanpreread || scatter meanpreread rankmeanpreread, ytitle("Mean probability (%)") xtitle("Commission on Cancer-Accredited Facilities (N = 1,139)") xlabel(0(100)1200) legend(order(2 "Facility-level adjusted mean probabilities of unplanned 30-day readmission rates (based on mixed-effects hierarchical logistic regression model)" )) legend(size(tiny))











/*BELOW HERE JUST PLAYING AROUND*/

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
