*********************************************************************************
*	Project:		TATU PAMOJA			   					 					*
*	Description :	Cleaning and fixing of errors in Laboratory Results Form008	*	
*	Date created:	January 18, 2020                                            *
*	Programer: 		Otieno, Fredrick                               	         	*
*	Date modified:	                                           					*
*	Mdified by:																	*
*	STATA Ver:  	14.2                                                     	*
********************************************************************************* 
		
cd "\\NRHS-RTI01\Study Documents\TTP\Data\Clean Data"
clear

// IMPORTING LABORATORY RESULTS
*******************************
*Gene X-Pert
import excel "\\NRHS-RTI01\Study Documents\TTP\Data\Raw Data\Excel\Laboratory Results.xlsx", sheet("XPert") firstrow
count
br

*Standardising Visit ID
tab visitid
label def visitid 1 "Baseline Enrolment Visit", add modify
label def visitid 3 "3 Month Quarterly Visit", add modify
label def visitid 6 "6 Month Half Yearly Visit", add modify
label def visitid 9 "9 Month Quarterly Visit", add modify
label def visitid 12 "12 Month Yearly Visit", add modify
label value visitid visitid
tab visitid

*Standardise Instrument Names
gen instrmnt = "TP08"

*Label Variables
label def result 0 "Negative", add modify
label def result 1 "Positive", add modify
label value xpertresult result 

label def yesno 0 "No", add modify
label def yesno 1 "Yes", add modify
label value inv2a yesno

//CHECKING FOR DUPLICATES
sort today subject visitid    
quietly by today subject visitid: gen dup = cond(_N==1,0,_n)
tab dup
list today subject visitid staffid if dup > 0
count if dup == 2 | dup == 3
drop if dup >= 2
drop dup


*Housekeeping and saving
drop if today == . & subject == . & visitid == .
order today subject visitid staffid
sort visitid today subject 
compress

*Saving all
save TTP008XPertFinal, replace
count

clear

*Saving Baseline 
use TTP008XPertFinal
count
drop if visitid == 3 | visitid == 6 | visitid == 9 | visitid == 12
count
save TTP008XPertBaseline, replace

*Saving Month3 Follow ups
clear
use TTP008XPertFinal
count
drop if visitid == 1 | visitid == 6 | visitid == 9 | visitid == 12
count
save TTP008XPertM3, replace

*Saving Month 6 Follow ups
clear
use TTP008XPertFinal
count
drop if visitid == 1 | visitid == 3 | visitid == 9 | visitid == 12
count
save TTP008XPertM6, replace

*Saving Month 9 Follow ups
clear
use TTP008XPertFinal
count
drop if visitid == 1 | visitid == 3 | visitid == 6 | visitid == 12
count
save TTP008XPertM9, replace

*Saving Month 12 Follow ups
clear
use TTP008XPertFinal
count
drop if visitid == 1 | visitid == 3 | visitid == 6 | visitid == 9
count
save TTP008XPertM12, replace

clear



*END*

