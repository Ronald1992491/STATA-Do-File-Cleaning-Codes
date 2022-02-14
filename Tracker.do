*********************************************************************************
*	Project:		Tatu Pamoja		   					 						*
*	Description :	Comparing Tracker to Datasets							    *	
*	Date created:	December 16, 2020                                           *
*	Programer: 		Otieno, Fred	                              	        	*
*	Date modified:                                              				*
*	STATA Ver    :  14.2                                                        *
********************************************************************************* 
cd "\\NRHS-RTI01\Study Documents\TTP\Data\Clean Data"
clear

*IMPORTING TTP PARTICIPANT TRACKER 
**************************************
*import excel "\\NRHS-RTI01\Study Documents\TTP\Study Updates\TTP Study Tracker.xlsx", sheet("Participant IDs") cellrange(A2:BP370) firstrow
import excel "\\NRHS-RTI01\Study Documents\TTP\Study Updates\TTP Study Tracker.xls", sheet("Participant IDs") cellrange(A2:BP370) firstrow
br

rename A			  subject
destring subject, replace

gen progid = substr(B,-6,.)
destring progid, replace
label var progid 	"Programme ID"

gen elig = "1" if Eligible == "Yes"
replace elig = "0" if Eligible == "No"
destring elig, replace
label def elig 1 "Yes",add modify
label def elig 0 "No",add modify
label value elig elig

gen enrolled = "1" if Enrolled == "Yes"
replace enrolled = "0" if Enrolled == "No"
replace enrolled = "2" if Enrolled == "Withdrawn"
destring enrolled, replace
label def enrolled 1 "Yes",add modify
label def enrolled 0 "No",add modify
label def enrolled 2 "Withdrawn",add modify
label value enrolled enrolled

tab Enrolled
list subject  if enrolled == . & elig == 1
br if enrolled == . & elig == 1
label value enrolled enrolled
br subject Enrolled  if  elig != . & enrolled == 1

rename Date          today 
destring today, replace 
desc today


rename E              dateenrol
rename G              datesero
rename Status         seroconversion
rename BeginWindow    begin030090	
rename Optimal        optimal030090	 	
rename CloseWindow    close030090	
rename VisitStatus    status030090
rename VisitDate      today030090

rename N              begin060180
rename O              optimal060180
rename P              close060180
rename Q              status060180
rename R              today060180
	
rename S              begin090270
rename T              optimal090270
rename U              close090270
rename V              status090270
rename W              today090270
	
rename X              begin120365 	
rename Y              optimal120365		
rename Z              close120365 	
rename AA             status120365 	
rename AB             today120365
		
rename AC             begin150456 	
rename AD             optimal150456	
rename AE             close150456	
rename AF             status150456	
rename AG             today150456
		
rename AH             begin180548	
rename AI             optimal180548		
rename AJ             close180548	
rename AK             status180548	
rename AL             today180548
	
rename AM             begin210639
rename AN             optimal210639		
rename AO             close210639	
rename AP             status210639	
rename AQ             today210639	

rename AR             begin240730 	
rename AS             optimal240730 	
rename AT             close240730 		
rename AU             status240730		
rename AV             today240730 	 	
	
rename AW             begin270821
rename AX             optimal270821	
rename AY             close270821		
rename AZ             status270821	
rename BA             today270821	
	
rename BB             begin300913 	
rename BC             optimal300913	
rename BD             close1300913	
rename BE             status300913 	
rename BF             today300913  	
	
rename BG             begin1331003	
rename BH             optimal331003
rename BI             close331003
rename BJ             status331003	
rename BK             today331003	

rename BL             begin361095	
rename BM             optimal361095	
rename BN             close361095		
rename BO             status361095	
rename BP             today361095  

tab1 elig enrolled, m
tab status030090
tab status060180

tab Eligible, m
count if Eligible == "" & enrolled == .
drop if Eligible == "" & enrolled == .
drop if Eligible == ""
tab Eligible, m
sort subject
br subject elig enrolled  if elig == 1
*rename today120365 today


//CHECKING FOR DUPLICATES
sort today subject elig 
quietly by today subject:  gen dup = cond(_N==1,0,_n)
tab dup
list today subject elig if dup > 0
drop dup


*Housekeeping and saving
order today subject progid elig enrolled dateenrol seroconversion
drop B Eligible Enrolled
drop if elig == . & enrolled == . & today == .
br subject today  elig  if elig == 1 & enrolled == .

replace seroconversion = "0" if seroconversion == "No"
replace seroconversion = "1" if seroconversion == "Yes"

replace status030090 = "0" if status030090 == "No"
replace status030090 = "1" if status030090 == "Yes"

replace status060180 = "0" if status060180 == "No"
replace status060180 = "1" if status060180 == "Yes"

replace status090270 = "0" if status090270 == "No"
replace status090270 = "1" if status090270 == "Yes"
replace status090270 = "2" if status090270 == "Withdrawn"

replace status120365 = "0" if status120365 == "No"
replace status120365 = "1" if status120365 == "Yes"

replace status150456 = "0" if status150456 == "No"
replace status150456 = "1" if status150456 == "Yes"
replace status150456 = "2" if status150456 == "Withdrawn"

replace status180548 = "0" if status180548 == "No"
replace status180548 = "1" if status180548 == "Yes"
replace status180548 = "2" if status180548 == "Withdrawn"

replace status210639 = "0" if status210639 == "No"
replace status210639 = "1" if status210639 == "Yes"
/*
replace status240730 = "0" if status240730 == "No"
replace status240730 = "1" if status240730 == "Yes"

replace status270821 = "0" if status270821 == "No"
replace status270821 = "1" if status270821 == "Yes"

replace status300913 = "0" if status300913 == "No"
replace status300913 = "1" if status300913 == "Yes"

replace status331003 = "0" if status331003 == "No"
replace status331003 = "1" if status331003 == "Yes"

replace status361095 = "0" if status361095 == "No"
replace status361095 = "1" if status361095 == "Yes"
*/


destring seroconversion status030090 status060180 status090270 status120365 ///
status150456 status180548 status210639 status240730 status270821 ///
status300913 status331003 status361095, replace

label def yesno 1 "Yes",add modify
label def yesno 0 "No",add modify
label def yesno 2 "Withdrawn",add modify
foreach var of varlist (seroconversion status030090 status060180 status090270 ///
status120365 status150456 status180548 status210639 status240730 ///
status270821 status300913 status331003 status361095){
label value `var' yesno
}	

compress
destring today, replace
save trackingttp, replace
count

/*Housekeeping and saving month 3 follow up visits
use trackingttp
keep if status030090 == 1
compress
save trackingttpM3, replace
count
clear

*Housekeeping and saving month 6 follow up visits
use trackingttp
keep if status060180 == 1
compress
save trackingttpM6, replace
count
clear

*Housekeeping and saving month 9 follow up visits
use trackingttp
keep if status090270 == 1
compress
save trackingttpM9, replace
count
clear

*Housekeeping and saving month 12 follow up visits
use trackingttp
keep if status120365 == 1
compress
save trackingttpM12, replace
count
clear

*Housekeeping and saving month 15 follow up visits
use trackingttp
keep if status150456 == 1
compress
save trackingttpM15, replace
count
clear

*Housekeeping and saving month 18 follow up visits
use trackingttp
keep if status180548 == 1
compress
save trackingttp18, replace
count
clear

*Housekeeping and saving month 21 follow up visits
use trackingttp
keep if status210639 == 1
br status210639 
desc status210639 
compress
save trackingttp21, replace
count
clear

*Housekeeping and saving month 24 follow up visits
use trackingttp
keep if status240730 == 1
compress
save trackingttpM24, replace
count
clear

*Housekeeping and saving month 27 follow up visits
use trackingttp
keep if status270821 == 1
compress
save trackingttpM27, replace
count
clear

*Housekeeping and saving month 30 follow up visits
use trackingttp
br status300913
keep if status300913 == 1
compress
save trackingttpM30, replace
count
clear

*Housekeeping and saving month 33 follow up visits
use trackingttp
br status331003
keep if status331003 == 1
compress
save trackingttpM33, replace
count
clear

*Housekeeping and saving month 36 follow up visits
use trackingttp
keep if status361095 == 1
compress
save trackingttpM36, replace
count
sort subject
br subject today status361095
count
*/
clear


