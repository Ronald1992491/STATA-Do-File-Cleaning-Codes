*********************************************************************************
*	Project:		TATU PAMOJA			   					 					*
*	Description :	Cleaning and fixing of errors for the HIV Testing Form 002	*	
*	Date created:	October 18, 2019                                            *
*	Programer: 		Otieno, Fredrick                               	         	*
*	Date modified:	                                           					*
*	Mdified by:																	*
*	STATA Ver    :  14.2                                                     	*
********************************************************************************* 
		
cd "\\NRHS-RTI01\Study Documents\TTP\Data\Clean Data"
clear

// IMPORTING CAPI HTS DATA
***********************************
*Baseline
use "\\NRHS-RTI01\Study Documents\TTP\Data\Raw Data\STATA\TTP002"
count
br

*Dropping wrong Interviews
tab subjects, m
tab subject, m
tab subjectu, m
drop if subject == . & subjects == . & subjectu == .
list subject subjectu subjects if subject == 99999999
replace subject = subjects if subject == 99999999 & subjects != 999999
replace subject = subjectu if subject == 99999999 & subjectu != 9999999
sort subject

*Destring variables
destring staffid1 staffid2 visitid1, replace

*Separating Study Specific HTS
tab study, m
tab study, nolab m
list subject subjects subjectu study if study == 3
list subject subjects subjectu study if study == 2
list subject subjects subjectu study if study == 1
list subject subjects subjectu study if study == .

replace study = 1 if subject >= 31100011 & subject <= 33000000
replace study = 2 if subject >= 500011 & subject <= 610000
replace study = 3 if subject >= 6100011 & subject <= 6200000
tab study, m
tab study visitid, m
list subject subjects subjectu study visitid if visitid == 99

*Saving all
compress
save HTS002FinalAll, replace
count 

*Separating Study Specific HTS
tab study, m
tab study, nolab
list subject subjects subjectu if study == .

*TTP
keep if study == 1
count
drop subjects pids visitids subjectu pidu
order staffid1 today subject visitid study age hts14
sort subject today hts14
compress
tab hts14
count
save TTP002FinalAll, replace
clear

*Shauriana
use HTS002FinalAll
keep if study == 2
count
drop subject pid visitid
rename subjects		subject
rename pids			pid
rename visitids		visitid
order staffid1 today subject visitid study age hts14
sort  subject today  hts14
compress
tab hts14
count
save SHA002FinalAll, replace
clear

*URCHOICE
use HTS002FinalAll
keep if study == 3
count
drop subject pid visitid
rename subjectu		subject
rename pidu			pid
order staffid1 today subject  study age hts14
sort subject today hts14
compress
tab hts14
count
save UCH002FinalAll, replace
clear

*Data Management of TTP
use TTP002FinalAll
count
br

*Standardising Visit ID
tab visitid, m
tab visitid, nolab
replace visitid = 27 if visitid == 10
replace visitid = 24 if visitid == 9
replace visitid = 21 if visitid == 8
replace visitid = 18 if visitid == 7
replace visitid = 15 if visitid == 6
replace visitid = 12 if visitid == 5
replace visitid = 9 if visitid == 4
replace visitid = 6 if visitid == 3
replace visitid = 3 if visitid == 2
replace visitid = 1 if visitid == 0
label def visitid 1 "Baseline Enrolment Visit", add modify
label def visitid 3 "3 Month Quarterly Visit", add modify
label def visitid 6 "6 Month Half Yearly Visit", add modify
label def visitid 9 "9 Month Quarterly Visit", add modify
label def visitid 12 "12 Month Yearly Visit", add modify
label def visitid 15 "15 Month Quarterly Visit", add modify
label def visitid 18 "18 Month Half Yearly Visit", add modify
label def visitid 21 "21 Month Quarterly Visit", add modify
label def visitid 24 "24 Month Yearly Visit", add modify
label def visitid 27 "27 Month Quarterly Visit", add modify

label value visitid visitid
tab visitid, m

/*
list subject subjects subjectu visitid visitids if visitid == 99
gen visitidu = 9
replace visitidu = 1 if inrange(subjectu, 6100000, 6200000)
label def visitidu 1 "Baseline Enrolment Visit", add modify
label value visitidu visitidu
list subject subjects subjectu visitid visitids visitidu if visitid == 99
list subject subjects subjectu visitid visitids visitidu if visitids == 9 & inrange(subjects, 500001, 520000)
*replace visitids = 1 if inrange(subjects, 500001, 500110)
label def visitids 1 "Baseline Enrolment Visit", add modify
label value visitids visitids
list subject subjects subjectu visitid visitids visitidu if visitid == 99
*/

*Standardise Instrument Names
tab instrmnt, m
replace instrmnt = "TP02" if instrmnt == "002" & subject != .
replace instrmnt = "TP02" if instrmnt == "ID01A" & subject != .
tab instrmnt, m

tab1 staffid1 staffid2
tab staffid1 staffid2
tab hts14
tab today
tab1 subject pid

*Renaming Variables
rename pbi4            TP002pbi4        
rename pbi5            TP002pbi5        
rename pbi6            TP002pbi6        
rename pbi7            TP002pbi7        
rename pbi8            TP002pbi8        
rename pbi9            TP002pbi9        
rename pbi10           TP002pbi10       
rename pbi11           TP002pbi11       
rename pbi12           TP002pbi12       
rename cs1             TP002cs1         
rename cs2             TP002cs2         
rename cs3             TP002cs3         
rename cs4             TP002cs4         
rename hts1            TP002hts1        
rename hts2            TP002hts2        
rename hts3            TP002hts3        
rename hts4            TP002hts4        
rename hts5            TP002hts5        
rename hts6            TP002hts6        
rename hts7            TP002hts7        
rename hts8            TP002hts8        
rename hts9            TP002hts9        
rename hts10           TP002hts10       
rename hts11           TP002hts11       
rename hts12           TP002hts12       
rename hts13           TP002hts13       
rename hts14           TP002hts14       
rename hts15           TP002hts15       
rename hts16           TP002hts16       
rename hts17           TP002hts17       
rename hts18           TP002hts18       
rename hts19           TP002hts19       
rename hts20           TP002hts20       
rename hts21           TP002hts21       
rename hts22           TP002hts22       
rename hts23           TP002hts23       
rename hts24           TP002hts24       
rename clinotes        TP002clinotes    
rename clinarr         TP002clinarr   

//Correcting Interview Dates to Allow for Merging
replace today = td(19feb2021) if today == td(24feb2021) & subject == 31100090
replace today = td(16jan2020) if today == td(15dec2020) & subject == 31100489
replace today = td(06dec2020) if today == td(11dec2020) & subject == 31100618
replace today = td(06dec2020) if today == td(16dec2020) & subject == 31100649
replace today = td(06sep2021) if today == td(08sep2021) & subject == 31100649
replace today = td(06dec2020) if today == td(17dec2020) & subject == 31100748
replace today = td(08dec2020) if today == td(17dec2020) & subject == 31100779
replace today = td(08sep2021) if today == td(14sep2021) & subject == 31100793
replace today = td(12sep2021) if today == td(14sep2021) & subject == 31100816
replace today = td(18dec2020) if today == td(22dec2020) & subject == 31100946
replace today = td(19dec2020) if today == td(23dec2020) & subject == 31100953
replace today = td(18dec2020) if today == td(21dec2020) & subject == 31100960

replace today = td(05feb2020) if today == td(17feb2020) & subject == 31101011
replace today = td(21mar2021) if today == td(22mar2020) & subject == 31101035
replace today = td(22mar2021) if today == td(23mar2021) & subject == 31101042
replace today = td(19dec2020) if today == td(21dec2020) & subject == 31101073
replace today = td(22mar2021) if today == td(29mar2021) & subject == 31101127
replace today = td(19dec2020) if today == td(22dec2020) & subject == 31101172
replace today = td(05jul2021) if today == td(07jul2021) & subject == 31101394
replace today = td(21sep2021) if today == td(09nov2021) & subject == 31101509
replace today = td(25feb2020) if today == td(15dec2020) & subject == 31101530
replace today = td(25feb2020) if today == td(26feb2020) & subject == 31101585
replace today = td(17oct2020) if today == td(23dec2020) & subject == 31101622
replace today = td(17jul2021) if today == td(23jul2021) & subject == 31101642
replace today = td(14mar2020) if today == td(15dec2020) & subject == 31101660
replace today = td(17jan2022) if today == td(18jan2022) & subject == 31101660

replace today = td(22nov2020) if today == td(25nov2020) & subject == 31102285
replace today = td(09nov2020) if today == td(11nov2020) & subject == 31102292
replace today = td(20apr2021) if today == td(01jul2021) & subject == 31102315

replace today = td(21apr2021) if today == td(01jul2021) & subject == 31102490
replace today = td(21apr2021) if today == td(01jul2021) & subject == 31102506
replace today = td(22apr2021) if today == td(01jul2021) & subject == 31102339
replace today = td(19may2021) if today == td(01jul2021) & subject == 31103183

replace today = td(05nov2020) if today == td(23nov2020) & subject == 31102520
replace today = td(06dec2020) if today == td(22dec2020) & subject == 31102568
replace today = td(05dec2020) if today == td(17dec2020) & subject == 31102582
replace today = td(05dec2020) if today == td(18dec2020) & subject == 31102612
replace today = td(05dec2020) if today == td(21dec2020) & subject == 31102643
replace today = td(05feb2020) if today == td(13feb2020) & subject == 31102971
replace today = td(23mar2021) if today == td(01apr2021) & subject == 31102988
replace today = td(23mar2021) if today == td(26mar2021) & subject == 31103018

//Correcting wrong visit Ids
tab visitid, m
replace visitid = 3  if subject == 31100489 & today == td(16jan2020)
replace visitid = 12 if subject == 31100618 & today == td(06dec2020)
replace visitid = 12 if subject == 31100649 & today == td(06dec2020)
replace visitid = 12 if subject == 31100748 & today == td(06dec2020)
replace visitid = 12 if subject == 31100779 & today == td(08dec2020)
replace visitid = 12 if subject == 31100960 & today == td(18dec2020)

replace visitid = 12 if subject == 31101073 & today == td(19dec2020)
replace visitid = 15 if subject == 31101127 & today == td(22mar2021)
replace visitid = 12 if subject == 31101622 & today == td(15jan2021)

replace visitid = 9  if subject == 31102568 & today == td(06dec2020)
replace visitid = 9  if subject == 31102582 & today == td(05dec2020)
replace visitid = 9  if subject == 31102612 & today == td(05dec2020)
replace visitid = 9  if subject == 31102643 & today == td(05dec2020)
replace visitid = 15 if subject == 31102674 & today == td(02jun2021)

replace visitid = 9  if subject == 31102827 & today == td(02nov2020)
replace visitid = 18 if subject == 31102841 & today == td(03sep2021)
replace visitid = 9  if subject == 31102926 & today == td(18dec2020)
replace visitid = 9  if subject == 31102971 & today == td(18dec2020)

replace visitid = 1  if subject == 31103039 & today == td(07feb2020)
replace visitid = 9  if subject == 31103121 & today == td(16dec2020)
replace visitid = 12 if subject == 31103336 & today == td(04mar2021)

//Replacing wrong PID
replace subject= 31100779 if subject==31102128
replace dob = td(19oct1994) if subject==31100830 & visitid==21
replace calcage = 26 if subject == 31100830 & visitid==21

//dropping unknown interview
drop if subject==31103138 & today==td(19may2021)
drop if subject==31102124 & today==td(08jun2021)
drop if subject==31102483 & today==td(01jul2021)

//Correcting wrong Subject ID
replace subject = 31101462  if subject == 31101463 & visitid == 12 & today == td(17dec2020)

//Correcting start time and end time.
replace start= tc(12:25::00) if subject ==31100854 & today==td(03may2021)
replace endtime= tc(12:55::00) if subject ==31100854 & today==td(03may2021)


//Correcting HIV Test Results for Inconclusive
tab TP002hts14, m
tab TP002hts14, nolab
list subject visitid today TP002hts14 if TP002hts14 == 2
replace TP002hts14 = 0 if subject == 31103107 & today == td(17dec2020) /* XPert result*/
list subject visitid today TP002hts1 TP002hts8 TP002hts12 TP002hts14 ///
TP002hts15 if TP002hts14 == 9

//Dropping wrong interviews
*drop if subject == 31102322 & today == td(27oct2020) & visitid == 12

*Housekeeping and saving
sort today subject visitid    
quietly by today subject visitid: gen dup = cond(_N==1,0,_n)
tab dup
list today subject visitid site staffid1 compname TP002hts14 if dup > 0
count if dup >= 2
drop if dup >= 2
drop dup
order staffid1 today subject instrmnt compname site section visitid age TP002hts14
sort TP002hts14 today subject 
compress
tab TP002hts14
save TTP002Final, replace

*Saving Baseline 
use TTP002Final
count
drop if visitid != 1
count
save TTP002Baseline, replace

*Saving Month3 Follow ups
clear
use TTP002Final
count
drop if visitid != 3 
count
save TTP002M3, replace

*Saving Month 6 Follow ups
clear
use TTP002Final
count
drop if visitid != 6
count
save TTP002M6, replace

*Saving Month 9 Follow ups
clear
use TTP002Final
count
drop if visitid != 9
count
save TTP002M9, replace

*Saving Month 12 Follow ups
clear
use TTP002FinalAll
drop if visitid != 12
count
save TTP002M12, replace

*Saving Month 15 Follow ups
clear
use TTP002Final
drop if visitid != 15
count
save TTP002M15, replace

*Saving Month 18 Follow ups
clear
use TTP002Final
drop if visitid != 18
count
save TTP002M18, replace

*Saving Month 21 Follow ups
clear
use TTP002Final
drop if visitid != 21
count
save TTP002M21, replace

*Saving Month 24 Follow ups
clear
use TTP002Final
drop if visitid != 24
count
save TTP002M24, replace
clear

*Saving Month 27 Follow ups
clear
use TTP002Final
drop if visitid != 27
count
save TTP002M27, replace
clear

*END*

