/*File to just plot hospital-level readmission rates with 95% CI for each HOSP_NRD*/
/*DOES NOT use the Random effects Intercepts*/

#delimit;
set more off;
use "NRD_2014_Core_Excluded.dta", replace;

/*Generate hospital readmit rate*/
bysort HOSP_NRD: egen hosp_readmit_rate = mean(READMIT);

summarize hosp_readmit_rate, detail;

by hosp_readmit_rate, sort: gen nvals_hosp_readmit_rate= _n == 1 ;
count if nvals_hosp_readmit_rate==1 ;

bysort HOSP_NRD: egen sd_hosp_readmit = sd(READMIT);

by sd_hosp_readmit, sort: gen nvals_sd_hosp_readmit= _n == 1 ;
count if nvals_sd_hosp_readmit==1 ;

/*Standard Error of the Mean*/
gen se_mean= sd_hosp_readmit/sqrt(CASELOAD);

	gen lower_ci=hosp_readmit_rate-1.96*se_mean;
	gen upper_ci=hosp_readmit_rate+1.96*se_mean;
	
drop if CASELOAD<=1;
	
/*Catepillar Plots*/

/*One line per hospital - ok because all analysis here and below are hospital level. */
by HOSP_NRD, sort: gen nvals= _n == 1 ;
keep if nvals==1;
drop nvals;



/*Ranks hospitals by unadjusted readmission rate for catepillar plots. */
	egen rank_readmit_fac=rank(hosp_readmit_rate);
	drop if hosp_readmit_rate==.;
	
collapse  
	/*Hospital Variables*/
	HOSP_BEDSIZE
	H_CONTROL
	CASELOAD
	HOSP_URCAT4
	HOSP_UR_TEACH
	CASELOAD_QUART
	/*Hospital Readmit Outcomes*/
	hosp_readmit_rate
	lower_ci
	upper_ci
	rank_readmit_fac,	
		by(HOSP_NRD);

	by hosp_readmit_rate, sort: gen nvals_hosp_readmit_rate= _n == 1 ;
count if nvals_hosp_readmit_rate==1 ;

/*Graph for the Paper */
/*Error Bars Skip Every Other Y Axis*/	
		
#delimit;

	
#delimit;
	twoway 
		(rcap upper_ci lower_ci rank_readmit_fac, lcolor(gs10))
		(scatter hosp_readmit_rate rank_readmit_fac, msymbol(smsquare) mcolor(gs0)),
		graphregion(color(white)) 
		bgcolor(white) 
		legend(off)
		title("Figure 1: Post-Cystectomy 30-day Readmission Rates" 
		"at 320 US Hospitals (Unadjusted) with 95% Confidence Intervals"
		  " ", 
		  span color(black) size(4))  
		yla(0 "0"  0.20 "20"  0.40 "40"  0.6 "60"  0.8 "80" 1.0 "100") 
	ytitle(
		"Percentage of Cystectomy Patients Readmitted" 
		"Within 30 Days, % (95% CI)" 
		" ")
	xtitle("Hospital Rank, 1-320" "(least to greatest readmission rate)");
		#delimit cr;

/*	
	twoway 
		(scatter lower_ci rank_readmit_fac, msymbol(circle_hollow) mcolor(gs10) )
		(scatter upper_ci rank_readmit_fac, msymbol(circle_hollow) mcolor(gs10))
		(scatter hosp_readmit_rate rank_readmit_fac, msymbol(circle_hollow) mcolor(gs0)),
		graphregion(color(white)) 
		bgcolor(white) 
		legend(off)
		title("Figure 1: Unadjusted Post-Cystectomy 30-day Readmission Rates" 
		"at 341 US Hospitals"
		  " ", 
		  span color(black) size(4))  
		yla(0 "0"  0.20 "20"  0.40 "40"  0.6 "60"  0.8 "80" 1.0 "100") 
	ytitle(
		"Percentage of Cystectomy Patients Readmitted" 
		"Within 30 Days, % (95% CI)" 
		" ")
	xtitle("Hospital Rank, 1-341" "(least to greatest readmission rate)");;
		#delimit cr;



*/
			/* Test Graphs 
			/*Dot Plot Bars */	


			#delimit;		
			twoway 
				(scatter lower_ci rank_readmit_fac, msymbol(point) mcolor(gs10) )
				(scatter upper_ci rank_readmit_fac, msymbol(point) mcolor(gs10))
				(scatter hosp_readmit_rate rank_readmit_fac, msymbol(point) mcolor(gs0)), 
				legend(off)
				graphregion(color(white)) 
				bgcolor(white) 
				title(
					"Figure 1: Hospital Level  Readmission Rates"
					"with 95% Confidence Intervals"
					" ", 
					  span color(black) size(4))  
				yla(0 "0" 0.10 "10"  0.20 "20" 0.30 "30" 0.40 "40" 0.5 "50" 0.6 "60" 0.7 "70" 0.8 "80" 0.9 "90" 1.0 "100") 
					ytitle(
					"Percentage of Cystectomy Patients Readmitted" 
					"Within 30 Days, (%, 95% CI)" " ")
				xtitle("Hospital Rank" "(least to greatest readmission rate)");
				#delimit cr
				

			/*Dot Plot Bars, Skip Every Other Y Line */	


			#delimit;		
			twoway 
				(scatter lower_ci rank_readmit_fac, msymbol(point) mcolor(gs10) )
				(scatter upper_ci rank_readmit_fac, msymbol(point) mcolor(gs10))
				(scatter hosp_readmit_rate rank_readmit_fac, msymbol(point) mcolor(gs0)), 
				legend(off)
				graphregion(color(white)) 
				bgcolor(white) 
				title("Figure 1: Hospital Level  Readmission Rates"
					  "with 95% Confidence Intervals"
					  " ", 
					  span color(black) size(4))  
					yla(0 "0"  0.20 "20"  0.40 "40"  0.6 "60"  0.8 "80" 1.0 "100") 
				ytitle(
					"Percentage of Cystectomy Patients Readmitted" 
					"Within 30 Days, % (95% CI)" 
					" ")
				xtitle("Hospital Rank" "(least to greatest readmission rate)");
				#delimit cr
				
			/*Small Square Plot */	


			#delimit;		
			twoway 
				(scatter lower_ci rank_readmit_fac, msymbol(smsquare) mcolor(gs10) )
				(scatter upper_ci rank_readmit_fac, msymbol(smsquare) mcolor(gs10))
				(scatter hosp_readmit_rate rank_readmit_fac, msymbol(smsquare) mcolor(gs0)), 
				legend(off)
				graphregion(color(white)) 
				bgcolor(white) 
				title("Figure 1: Hospital Level  Readmission Rates"
					  " ", 
					  span color(black) size(4))  
				yla(0 "0" 0.10 "10"  0.20 "20" 0.30 "30" 0.40 "40" 0.5 "50" 0.6 "60" 0.7 "70" 0.8 "80" 0.9 "90" 1.0 "100") ytitle("Probability of Readmission, (%)" " ")
				xtitle("Hospital Rank" "(least to greatest readmission rate)");
				#delimit cr
				
				
					
			/*Error Bars */	
			#delimit;
				twoway 
					(rcap upper_ci lower_ci rank_readmit_fac, lcolor(gs10))
					(scatter hosp_readmit_rate rank_readmit_fac, msymbol(square hollow) mcolor(gs5)),
					graphregion(color(white)) 
					bgcolor(white) 
					legend(off)
					title("Figure 1: Hospital Level  Readmission Rates"
						  "with 95% Confidence Intervals"
						  " ", 
						  span color(black) size(4))  
					yla(0 "0" 0.10 "10"  0.20 "20" 0.30 "30" 0.40 "40" 0.5 "50" 0.6 "60" 0.7 "70" 0.8 "80" 0.9 "90" 1.0 "100") ytitle("Probability of Readmission, (%)" " ")
					xtitle("Hospital Rank" "(least to greatest readmission rate)");
					#delimit cr;
					*/


		
/*Defining top and bottom deciles*/

xtile quartile_readmit=rank_readmit_fac, nquantiles(4)


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

summarize hosp_readmit_rate if quartile_readmit==4;
ci hosp_readmit_rate if quartile_readmit==4; 

summarize hosp_readmit_rate if quartile_readmit==1;
ci hosp_readmit_rate if quartile_readmit==1;


bysort quartile_readmit: egen median_readmit = median(hosp_readmit_rate);

bysort quartile_readmit: summarize hosp_readmit_rate;

gen low_readmit_rate=0;
replace low_readmit_rate=1 if quartile_readmit==1;

gen high_readmit_rate=0;
replace high_readmit_rate=1 if quartile_readmit==4;


/*Model for prediction of hospital characteristics are associated with high versus low readmit rate*/
#delimit;
regress high_readmit_rate
	i.HOSP_BEDSIZE
	i.H_CONTROL
	i.CASELOAD_QUART
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE;
	
	
logit low_readmit_rate 
	i.HOSP_BEDSIZE
	i.H_CONTROL
	i.CASELOAD_QUART
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE, or;
	
#delimit;
regress rank_readmit_fac
	i.HOSP_BEDSIZE
	i.H_CONTROL
	i.CASELOAD_QUART
	i.HOSP_UR_TEACH
	i.HOSP_BEDSIZE;
	
		
		
		
		
