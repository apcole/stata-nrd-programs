/* Code for combining the four databases for 2010 into a single dataset*/

/*Replace with directory which holds the 2010 Files*/

set more off 

cd /Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD/NRD_Merge/NRD_2010

use NRD_2010_Core.dta

describe

sort key_nrd

joinby key_nrd using NRD_2010_DX_PR_GRPS.dta

save NRD_2010_Core_DX_PR_GRPS.dta

clear all

use NRD_2010_Core_DX_PR_GRPS.dta

sort key_nrd

joinby key_nrd using NRD_2010_Hospital.dta

save NRD_2010_Core_DX_PR_GRPS_Hospital.dta

clear all

use NRD_2010_Core_DX_PR_GRPS_Hospital.dta

sort key_nrd

joinby key_nrd using NRD_2010_Severity.dta

save NRD_2010_All.dta
