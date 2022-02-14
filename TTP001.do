*********************************************************************************
*	Project:		TATU PAMOJA			   					 					*
*	Description :	Cleaning and fixing of errors for the Eligibility Form001	*	
*	Date created:	November 18, 2021                                            *
*	Programer: 		Ronald, Omolo                               	         	*
*	Date modified:	                                           					*
*	Mdified by:																	*
*	STATA Ver:  	14.2                                                     	*
********************************************************************************* 
		
cd "\\NRHS-RTI01\Study Documents\TTP\Data\Clean Data"
clear

// IMPORTING CAPI Eligibility DATA
***********************************
*Baseline
use "\\NRHS-RTI01\Study Documents\TTP\Data\Raw Data\STATA\TTP001"
count
br

*Destring variables
destring visitid staffid1 staffid2, replace

*Standardising Visit ID
tab visitid
*replace visitid = 12 if visitid == 4
*replace visitid = 9 if visitid == 3
*replace visitid = 6 if visitid == 2
*replace visitid = 3 if visitid == 1
replace visitid = 1 if visitid == 0
label def visitid 1 "Baseline Enrolment Visit", add modify
*label def visitid 3 "3 Month Quarterly Visit", add modify
*label def visitid 6 "6 Month Half Yearly Visit", add modify
*label def visitid 9 "9 Month Quarterly Visit", add modify
*label def visitid 12 "12 Month Yearly Visit", add modify
label value visitid visitid
tab visitid

*Standardise Instrument Names
tab instrmnt
replace instrmnt = "TP01" if instrmnt == "ID01"
tab instrmnt


*Correcting missing staffid2
tab1 staffid1 staffid2
tab staffid1 staffid2
list staffid1 today subject if staffid2 == .
replace staffid2 = 48 if staffid2 == . & subject == 31100397
tab1 staffid1 staffid2
tab staffid1 staffid2

tab eligible
label def eligible 1 "Yes",add modify
label def eligible 0 "No",add modify
label value eligible eligible
tab eligible

tab today
tab1 subject pid

replace today = td(08oct2019) if today == td(07oct2019) & subject == 31100106
*Did Screening and ACASI on 07OCT2019 and completed other procedures on 08OCT2019
replace today = td(08oct2019) if today == td(07oct2019) & subject == 31100113
*Did Screening and ACASI on 07OCT2019 and completed other procedures on 08OCT2019
replace today = td(06nov2019) if today == td(04nov2019) & subject == 31101028
*Did Screening and ACASI on 04NOV2019 and completed other procedures on 06NOV2019
replace subject = 31101769 if subject == 31101752 & start == tc(11:22::28)
replace pid = 31101769 if pid == 31101752 & start == tc(11:22::28)
*Screened 31101769 with subject and pid for 31101752 on 04dec2019
replace yesques = 0 if subject == 31102148
replace eligible = 0 if subject == 31102148
replace statuse = "ARE NOT ELIGIBLE to be in the TTP study.  You have not met one or more of the required criteria to be in this study." ///
if subject == 31102148
*31102148 Illiterate thus did not proceed with study

*Correcting Subject ID
replace subject = 31103138 if subject == 31103169 & staffid1== 34 

*Correcting Staff ID
replace staffid1 = 34 if staffid1 == 3 & subject== 31103466 




*Renaming Variables
rename a1              TP001a1    
rename a2              TP001a2
rename a3              TP001a3
rename a4              TP001a4
rename a5              TP001a5
rename a6              TP001a6
rename a7              TP001a7
rename a8              TP001a8
rename a9              TP001a9
rename a10             TP001a10
rename b1              TP001b1
rename b2              TP001b2

//Dropping wrong interviews
drop if subject == 31103329 & today == td(18feb2020) & visitid == 1
*The client had been enrolled in the TTP study PID 31101851 and  
* possed as a new client on 18feb2020 and screened again ad got another PID. 
drop if subject == 31103244 & today == td(14feb2020) & visitid == 1
*The client temporarily ineligible and rescreened again on 17feb2020 eligible  
drop if subject == 31100908 & today == td(01nov2019) & visitid == 1
*The client eligible at screening but refused to consent  
drop if subject == 31100922 & today == td(01nov2019) & visitid == 1
*The client eligible at screening but refused to consent  

//CHECKING FOR DUPLICATES
sort today subject visitid    
quietly by today subject visitid: gen dup = cond(_N==1,0,_n)
tab dup
list today subject visitid site staffid1 compname if dup > 0
count if dup >= 2
drop if dup >= 2
drop dup

*Droping blank interviews
drop if subject ==.

*Housekeeping and saving
order staffid1 today subject instrmnt compname site visitid eligible
sort eligible today subject 
compress
tab eligible

*Saving all
save TTP001Final, replace
count

*Saving eligibles
use TTP001Final
drop if eligible == 0
count
save TTP001FinalElig, replace
count

*Saving ineligibles use AM001Final
use TTP001Final
drop if eligible == 1
count
save TTP001FinalInelig, replace
count

clear


*END*

