/*McFaddens R Squared*/

/*Use .dta file created in the MODEL file which has criteria applied*/

# delimit; 
set more off;
cd "/Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD_RC_Predictors/Data";
use "ModelCohort.dta", replace; 
set more off;

/*FULL MODEL*/

xtmelogit READMIT 
	i.AGE_CAT 
	FEMALE 
	i.CCI_CAT 
	i.PAYOR 
	i.ZIPINC_QRTL, or 
		|| HOSP_NRD:, covariance(exchangeable) intpoints(20);

di %20.10fc `e(ll)';

logit READMIT;

di %20.10fc `e(ll)';


/*Full compared to Null model*/

		
/*Fixed effects only */
#delimit;
logit  READMIT 
	i.AGE_CAT
	FEMALE 
	i.CCI_CAT 
	i.PAYOR 
	i.ZIPINC_QRTL, or;
	
di %20.10fc `e(ll)';
		
		
/*Hospital (random effects only) - remove fixed effects*/
#delimit;

xtmelogit READMIT 
		|| HOSP_NRD:, covariance(exchangeable) intpoints(20);
	di %20.10fc `e(ll)';	
	
logit READMIT;

di %20.10fc `e(ll)';	
		
/*PATIENT (fixed effects only) - remove random effects term*/
#delimit;
xtmelogit READMIT 
	i.AGE_CAT 
	FEMALE 
	i.CCI_CAT 
	i.PAYOR 
	i.ZIPINC_QRTL 
	i.REHABTRANSFER || : covariance(identity) intpoints(20);
	
	
#delimit;
logit READMIT, or;

di %20.10fc `e(ll)';
	
