/*Combines NRD core files from 2010 to 2014 */

set more off 

cd /Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD/NRD_Merge/NRD_2010

use NRD_2010_Core.dta

cd /Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD/NRD_Merge/NRD_2011

append using NRD_2011_Core.dta 

cd /Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD/NRD_Merge/NRCD_2012

append using NRD_2012_Core.dta

cd /Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD/NRD_Merge/NRD_2013_v2

append using NRD_2013v2_Core.dta

cd /Users/Putnam_Cole/Dropbox/1_ResearchProjects/1_HarvardProjects/NRD/NRD_Merge/NRD_2014

append using NRD_2014_Core.dta

save 
