
/*File to plot ADJUSTED hospital-level readmission rates with 95% CI for each HOSP_NRD*/
/*DOES use the Random effects Intercepts*/

#delimit;
set more off;
use "NRD_2014_Core_Excluded_Predicted_Rates.dta", replace;





/*Catepillar Plots*/

/*One line per hospital - ok because all analysis here and below are hospital level. */
by HOSP_NRD, sort: gen nvals= _n == 1 ;
keep if nvals==1;
drop nvals;

/*Ranks hospitals by predicted readmission rate for catepillar plots.*/

egen rank_mu_pred_readmit_fac=rank(mu_pred_readmit_fac);
	
collapse  
	/*Hospital Variables*/
	H_CONTROL
	CASELOAD
	HOSP_URCAT4
	HOSP_UR_TEACH
	HOSP_BEDSIZE
	CASELOAD_QUART
	/*Hospital Readmit Outcomes*/
	mu_pred_readmit_fac
	lowerbound_mu_pred_readmit_fac
	upperbound_mu_pred_readmit_fac	
	rank_mu_pred_readmit_fac,	
		by(HOSP_NRD);

by mu_pred_readmit_fac, sort: gen nvals_mu_pred_readmit_fac= _n == 1 ;
count if nvals_mu_pred_readmit_fac==1 ;

/*Scatterplots*/

/*Dots for 95% CIs, using shortened Y Axis*/
	#delimit;		
	twoway 
		(scatter mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs5) )
		(scatter lowerbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs10) )
		(scatter upperbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs10)), 
		legend(off)
		graphregion(color(white)) 
		bgcolor(white) 
		title(
			"Figure 2: Estimated Probability of 30-Day Readmission at 320 US Hospitals" 
			"with 95% Confidence Intervals, Based on Facility Effects Only" 
			"(Holding Patient Characteristics Constant at Population Mean)"
			" ", 
				span color(black) size(4)) 
		ytitle(
			"Adjusted Probability of Readmission" 
			"%, (95% CI)")
			yla(0.26 "26" 0.28 "28" 0.30 "30" ) 
		xtitle(
			"Hospital Rank, 1-320" 
			"(least to greatest adjusted probability of readmission)");
		#delimit cr
/*		
/*Dots for 95% CIs*/
	#delimit;		
	twoway 
		(scatter mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs1) )
		(scatter lowerbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs10) )
		(scatter upperbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs10)), 
		legend(off)
		graphregion(color(white)) 
		bgcolor(white) 
		title(
			"Figure 1: Adjusted  Probabilities of Readmission" 
			"Based on Facility-level Random Effects Term" 
			"After Holding Patient Characteristics Constant at Population Average"
			"with 95% Confidence Intervals"
			" ", 
				span color(black) size(4))  
		yla(0 "0" 0.10 "10"  0.20 "20" 0.30 "30" 0.40 "40" 0.5 "50" ) 
			ytitle("Probability of Readmission, (%)" " ")
		xtitle("Hospital Rank" "(least to greatest adjusted probability of readmission)");
		#delimit cr

	

	
/*Lines for 95% CIs, full Y Axis*/
#delimit;
	twoway 
		(rcap upperbound_mu_pred_readmit_fac lowerbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, lcolor(gs10))
		(scatter mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs5)),
		graphregion(color(white)) 
		bgcolor(white) 
		legend(off)
		title(
			"Figure 1: Adjusted  Probabilities of Readmission" 
			"Based on Facility-level Random Effects Term" 
			"After Holding Patient Characteristics Constant at Population Average"
			"with 95% Confidence Intervals"
			" ", 
				span color(black) size(4)) 
		yla(0 "0" 0.10 "10"  0.20 "20" 0.30 "30" 0.40 "40" 0.5 "50" 0.6 "60" 0.7 "70" 0.8 "80" 0.9 "90" 1.0 "100") ytitle("Probability of Readmission, (%)" " ")
		xtitle("Hospital Rank" "(least to greatest readmission rate)");
		#delimit cr;


/*Lines for 95% CIs, full Y Axis*/
#delimit;
	twoway 
		(rcap upperbound_mu_pred_readmit_fac lowerbound_mu_pred_readmit_fac rank_mu_pred_readmit_fac, lcolor(gs10))
		(scatter mu_pred_readmit_fac rank_mu_pred_readmit_fac, msymbol(point) mcolor(gs5)),
		graphregion(color(white)) 
		bgcolor(white) 
		legend(off)
		title(
			"Figure 1: Adjusted  Probabilities of Readmission" 
			"Based on Facility-level Random Effects Term" 
			"After Holding Patient Characteristics Constant at Population Average"
			"with 95% Confidence Intervals"
			" ", 
				span color(black) size(4)) 
		yla(0.20 "20" 0.22 "22" 0.24 "24" 0.26 "26" 0.28 "28" 0.30 "30" )
			ytitle("Probability of Readmission, (%)" " ")
		xtitle("Hospital Rank" "(least to greatest readmission rate)");
		#delimit cr;

*/		
/*Defining top and bottom deciles*/

/*
#delimit;
count;
xtile quartile_readmit=mu_pred_readmit_fac, nquantiles(4);


/*Generate variable "readmit_high_low" which is one in the top decile, */
#delimit;
gen readmit_low=0;
replace readmit_low=1 if decile_readmit<=1;

label define readmit_low 
	1 "Least likely hospitals to readmit (Bottom Decile)";
label values readmit_low readmit_low;


#delimit;

summarize mu_pred_readmit_fac if decile_readmit==1;
ci mu_pred_readmit_fac if decile_readmit==1;
summarize mu_pred_readmit_fac if decile_readmit==10;
ci mu_pred_readmit_fac if decile_readmit==10;


/*Model for prediction of hospital characteristics are associated with high versus low readmit rate*/

#delimit;
		
logit readmit_low 
	i.HOSP_BEDSIZE
	i.H_CONTROL
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE
	CASELOAD
	TEN_OR_MORE, or;
*/

/*xtile decile_readmit=mu_pred_readmit_fac, nquantiles(10)


/*Generate variable "readmit_high_low" which is one in the top decile, */
#delimit;
gen readmit_high_low=.;
replace readmit_high_low=1 if decile_readmit==10;
replace readmit_high_low=0 if decile_readmit==1;

label define readmit_high_low 
	1 "Most likely hospitals to oreadmit (Top Decile)"
	0 "Least likely hospitals to observe readmit (Bottom Decile)";
label values readmit_high_low readmit_high_low;

count;






#delimit;

summarize mu_pred_readmit_fac if decile_readmit==10;
ci mu_pred_readmit_fac if decile_readmit==10; 

summarize mu_pred_readmit_fac if decile_readmit==1;
ci mu_pred_readmit_fac if decile_readmit==1;


bysort decile_readmit: egen median_readmit = median(mu_pred_readmit_fac);

bysort decile_readmit: summarize mu_pred_readmit_fac;

gen low_readmit_rate=0;
replace low_readmit_rate=1 if decile_readmit==1;

gen high_readmit_rate=0;
replace high_readmit_rate=1 if decile_readmit==10;

/*Model for prediction of hospital characteristics are associated with high versus low readmit rate*/
#delimit;
	
logit low_readmit_rate 
	i.HOSP_BEDSIZE
	i.H_CONTROL
	CASELOAD
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE, or;
	
logit high_readmit_rate 
	i.HOSP_BEDSIZE
	i.H_CONTROL
	CASELOAD
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE, or;
	
#delimit;
regress mu_pred_readmit_fac
	i.HOSP_BEDSIZE
	i.H_CONTROL
	i.CASELOAD_QUART
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE;

	
*/
	
xtile quartile_readmit=mu_pred_readmit_fac, nquantiles(4)


/*Generate variable "readmit_high_low" which is one in the top decile, */
#delimit;
gen readmit_high_low=.;
replace readmit_high_low=1 if quartile_readmit==4;
replace readmit_high_low=0 if quartile_readmit==1;

label define readmit_high_low 
	1 "Most likely hospitals to oreadmit (Top Decile)"
	0 "Least likely hospitals to observe readmit (Bottom Decile)";
label values readmit_high_low readmit_high_low;

count;






#delimit;

summarize mu_pred_readmit_fac if quartile_readmit==4;
ci mu_pred_readmit_fac if quartile_readmit==4; 

summarize mu_pred_readmit_fac if quartile_readmit==1;
ci mu_pred_readmit_fac if quartile_readmit==1;


bysort quartile_readmit: egen median_readmit = median(mu_pred_readmit_fac);

bysort quartile_readmit: summarize mu_pred_readmit_fac;

gen low_readmit_rate=0;
replace low_readmit_rate=1 if quartile_readmit==1;

gen high_readmit_rate=0;
replace high_readmit_rate=1 if quartile_readmit==4;

/*Model for prediction of hospital characteristics are associated with high versus low readmit rate*/
#delimit;
	
logit high_readmit_rate 
	i.HOSP_BEDSIZE
	i.H_CONTROL
	CASELOAD
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE, or;
	
logit high_readmit_rate 
	i.HOSP_BEDSIZE
	i.H_CONTROL
	i.CASELOAD_QUART
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE, or;

regress mu_pred_readmit_fac
	i.HOSP_BEDSIZE
	i.H_CONTROL
	i.CASELOAD_QUART
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE;

