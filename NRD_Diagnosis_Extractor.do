set more off

gen DxCheck=0 
label var DxCheck                      "1 if patient has Dx, 0 if not"


replace DxCheck=1 if dx1==Dx
replace DxCheck=1 if dx2==Dx
replace DxCheck=1 if dx3==Dx
replace DxCheck=1 if dx4==Dx 
replace DxCheck=1 if dx5==Dx 
replace DxCheck=1 if dx6==Dx 
replace DxCheck=1 if dx7==Dx 
replace DxCheck=1 if dx8==Dx 
replace DxCheck=1 if dx9==Dx 
replace DxCheck=1 if dx10==Dx 
replace DxCheck=1 if dx11==Dx 
replace DxCheck=1 if dx12==Dx 
replace DxCheck=1 if dx13==Dx 
replace DxCheck=1 if dx14==Dx 
replace DxCheck=1 if dx15==Dx 
replace DxCheck=1 if dx16==Dx 
replace DxCheck=1 if dx17==Dx 
replace DxCheck=1 if dx18==Dx 
replace DxCheck=1 if dx19==Dx 
replace DxCheck=1 if dx20==Dx 
replace DxCheck=1 if dx21==Dx 
replace DxCheck=1 if dx22==Dx 
replace DxCheck=1 if dx23==Dx 
replace DxCheck=1 if dx24==Dx 
replace DxCheck=1 if dx25==Dx 
replace DxCheck=1 if dx26==Dx 
replace DxCheck=1 if dx27==Dx 
replace DxCheck=1 if dx28==Dx 
replace DxCheck=1 if dx29==Dx 
replace DxCheck=1 if dx30==Dx 

tab DxCheck

keep if DxCheck==1

save  "NRD_2014_Core_diagnosis.dta" ,replace

clear all
