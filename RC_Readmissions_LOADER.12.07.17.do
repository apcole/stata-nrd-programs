clear all

set more off

/*replace filepath with direc that NRD .dta files are stored*/
cd /Users/Putnam_Cole/Dropbox/00_Databases/TestExtractNRD2014


/*replace with the NRD core .dta file*/
use NRD_2014_Core.dta

/*replace "185" with desired diagnostic code*/
/*185 = prostate cancer */

gen Dx="185"

/*creates new variable called "NRD year" which represents the year of that data*/
gen NRDyear=2014

/*labels each observation based of presence of diagnosis in one of 30 diagnostic variables and saves only those observartions*/
do NRD_Diagnosis_Extractor.do

clear all

use NRD_2014_Core_diagnosis.dta

merge m:m key_nrd using NRD_2014_DX_PR_GRPS.dta, assert(match master)
merge m:m key_nrd using NRD_2014_Hospital.dta, assert(match master)
merge m:m key_nrd using NRD_2014_Severity.dta, assert(match master)

save "NRD_2014_All_diagnosis.dta" ,replace
