*********************************************************************************
*	Project:		TATU PAMOJA			   					 					*
*	Description :	Cleaning and fixing of errors in Pharmacy Data Form009		*	
*	Date created:	January 18, 2020                                            *
*	Programer: 		Otieno, Fredrick                               	         	*
*	Date modified:	                                           					*
*	Mdified by:																	*
*	STATA Ver:  	14.2                                                     	*
********************************************************************************* 
		
cd "\\NRHS-RTI01\Study Documents\TTP\Data\Clean Data"
clear

// IMPORTING PHARMACY RESULTS
*****************************
*Baseline
import excel "\\NRHS-RTI01\Study Documents\TTP\Data\Raw Data\Excel\PrEP_Study Clients.xlsx", sheet("PrEP_Study Clients") firstrow
count
br

/*Standardising Visit ID
tab visitid
label def visitid 1 "Baseline Enrolment Visit", add modify
label def visitid 3 "3 Month Quarterly Visit", add modify
label def visitid 6 "6 Month Half Yearly Visit", add modify
label def visitid 9 "9 Month Quarterly Visit", add modify
label def visitid 12 "12 Month Yearly Visit", add modify
label value visitid visitid
tab visitid
*/

*Standardise Instrument Names
gen instrmnt = "TP09"

*Renaming Variables
rename ccc_number      		subject
rename date_of_birth   		dob
rename current_weight  		weight
rename current_height  		height
rename current_bsa     		bsa
rename current_bmi     		bmi
rename date_enrolled   		enroldate
rename start_regimen_date 	regimendate
rename status_change_date	statuschangedate

*Format dates
format %td dob enroldate regimendate statuschangedate prep_test_date ///
isoniazid_start_date isoniazid_end_date nextappointment clinicalappointment

*Maturity
tab maturity
replace maturity = "1" if maturity == "Adult"
replace maturity = "2" if maturity == "Adolescent"
replace maturity = "3" if maturity == "Child"
destring maturity, replace
label def maturity 1 "Adult", add modify
label def maturity 2 "Adolescent", add modify
label def maturity 3 "Child", add modify
label value maturity maturity 
tab maturity

*Sex
tab gender
replace gender = "1" if gender == "MALE"
replace gender = "2" if gender == "FEMALE"
destring gender, replace
label def gender 1 "Male", add modify
label def gender 2 "Female", add modify
label value gender gender 
tab gender

*Pregnant
tab pregnant
replace pregnant = "1" if pregnant == "YES"
replace pregnant = "0" if pregnant == "NO"
destring pregnant, replace
label def pregnant 1 "Yes", add modify
label def pregnant 0 "No", add modify
label value pregnant pregnant 
tab pregnant

*TB
tab tb
replace tb = "1" if tb == "YES"
replace tb = "0" if tb == "NO"
destring tb, replace
label def tb 1 "Yes", add modify
label def tb 0 "No", add modify
label value tb tb 
tab tb

*Smoke
tab smoke
replace smoke = "1" if smoke == "YES"
replace smoke = "0" if smoke == "NO"
destring smoke, replace
label def smoke 1 "Yes", add modify
label def smoke 0 "No", add modify
label value smoke smoke 
tab smoke

*Alcohol
tab alcohol
replace alcohol = "1" if alcohol == "YES"
replace alcohol = "0" if alcohol == "NO"
destring alcohol, replace
label def alcohol 1 "Yes", add modify
label def alcohol 0 "No", add modify
label value alcohol alcohol 
tab alcohol

*Service
tab service
replace service = "1" if service == "ART"
replace service = "2" if service == "HEPATITIS"
replace service = "3" if service == "PEP"
replace service = "4" if service == "PREP"
destring service, replace
label def service 1 "ART", add modify
label def service 2 "Hepatitis", add modify
label def service 3 "PEP", add modify
label def service 4 "PrEP", add modify
label value service service 
tab service

*Current Status
tab current_status
replace current_status = "1" if current_status == "Active"
replace current_status = "2" if current_status == "Deceased"
replace current_status = "3" if current_status == "Lost to follow-up"
replace current_status = "4" if current_status == "PEP end"
replace current_status = "5" if current_status == "Transfer in"
replace current_status = "6" if current_status == "Transfer out"
destring current_status, replace
label def current_status 1 "Active", add modify
label def current_status 2 "Deceased", add modify
label def current_status 3 "Lost to follow-up", add modify
label def current_status 4 "PEP end", add modify
label def current_status 5 "PEP end", add modify
label def current_status 6 "PEP end", add modify
label value current_status current_status 
tab current_status

*SMS
tab sms_consent
replace sms_consent = "1" if sms_consent == "YES"
replace sms_consent = "0" if sms_consent == "NO"
destring sms_consent, replace
label def sms_consent 1 "Yes", add modify
label def sms_consent 0 "No", add modify
label value sms_consent sms_consent 
tab sms_consent

*Partner Status
tab partner_status
replace partner_status = "1" if partner_status == "Concordant"
replace partner_status = "2" if partner_status == "Discordant"
replace partner_status = "3" if partner_status == "Unknown"
destring partner_status, replace
label def partner_status 1 "Concordant", add modify
label def partner_status 2 "Discordant", add modify
label def partner_status 3 "Unknown", add modify
label value partner_status partner_status 
tab partner_status

*Disclosure
tab disclosure
replace disclosure = "1" if disclosure == "YES"
replace disclosure = "0" if disclosure == "NO"
destring disclosure, replace
label def disclosure 1 "Yes", add modify
label def disclosure 0 "No", add modify
label value disclosure disclosure 
tab disclosure

*IS Tested
tab is_tested
replace is_tested = "1" if is_tested == "YES"
replace is_tested = "0" if is_tested == "NO"
destring is_tested, replace
label def is_tested 1 "Yes", add modify
label def is_tested 0 "No", add modify
label value is_tested is_tested 
tab is_tested

*PrEP Test Results
tab prep_test_result
replace prep_test_result = "1" if prep_test_result == "Positive"
replace prep_test_result = "0" if prep_test_result == "Negative"
destring prep_test_result, replace
label def prep_test_result 0 "Negative", add modify
label def prep_test_result 1 "Positive", add modify
label value prep_test_result prep_test_result 
tab prep_test_result

//CHECKING FOR DUPLICATES
sort subject dob gender    
quietly by subject dob gender: gen dup = cond(_N==1,0,_n)
tab dup
list subject dob gender if dup > 0
count if dup == 2 | dup == 3
drop if dup >= 2
drop dup

*Housekeeping and saving
drop if subject == "" & dob == . & gender == .
order subject enroldate dob gender 
sort enroldate subject  
compress

*Saving all
save TTP009Final, replace
count

clear

*Saving PrEP 
use TTP009Final
count
drop if subject <"31100000" | subject > "32100000"
destring subject, replace
count
save TTP009PrEP, replace
clear

*END*

