*********************************************************************************
*	Project:		TATU PAMOJA			   					 					*
*	Description :	Cleaning and fixing of errors for the Behavioural Survey003	*	
*	Date created:	December 04, 2021                                            *
*	Programer: 		Omolo, Ronald                               	         	*
*	Date modified:	                                           					*
*	Mdified by:																	*
*	STATA Ver:  	14.2                                                     	*
********************************************************************************* 
		
cd "\\NRHS-RTI01\Study Documents\TTP\Data\Clean Data"
clear

// IMPORTING ACASI Behavioural Survey DATA
******************************************
*Baseline
use "\\NRHS-RTI01\Study Documents\TTP\Data\Raw Data\STATA\TTP003"
count
br

*Dropping wrong Interviews
tab subjects, m
tab subject, m
tab subjectu, m
drop if subject == . & subjects == . & subjectu == .
drop if subject == 31000000
list subject subjectu subjects if subject == 99999999
replace subject = subjects if subject == 99999999 & subjects != 999999
replace subject = subjectu if subject == 99999999 & subjectu != 9999999
sort subject

*Destring variables
destring staffid1 staffid2, replace

*Separating Study Specific ACASI
tab study, m
tab study, nolab m
tab study1, m
tab1 study study1
list subject subjects subjectu study study1 if study != study1
list subject subjects subjectu study study1 if study == 3
list subject subjects subjectu study study1 if study == 2

list subject subjects subjectu study study1 if study == .
replace study = 1 if subject >= 31100011 & subject <= 33000000
replace study = 2 if subject >= 500011 & subject <= 610000
replace study = 3 if subject >= 6100011 & subject <= 6200000
tab study, m
tab study visitid, m
list subject subjects subjectu study study1 visitid if visitid == 99

*Saving all
compress
save ACASI003FinalAll, replace
count 

*TTP
keep if study == 1
count
drop subjects pids visitids subjectu pidu
order staffid1 today subject visitid study dob age calcage intlang
sort subject today
compress
count
save TTP003FinalAll, replace
clear

*Shauriana
use ACASI003FinalAll
keep if study == 2
count
list subject subjects subjectu if subject == 99999999
replace subject = subjects if subject == 99999999 
replace pid = pids if pid == 99999999 
drop subjects pids subjectu pidu
order staffid1 today subject visitid study dob age calcage intlang
sort  subject today
compress
count
save SHA003FinalAll, replace
clear

/*URCHOICE
use ACASI003FinalAll
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
save UCH003FinalAll, replace
clear
*/

*Data Management of TTP
use TTP003FinalAll
count
br
*Standardising Visit ID
tab visitid, m
tab visitid, nolab m
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
tab visitid, nolab

*Standardise Instrument Names
tab instrmnt, m
replace instrmnt = "TP03" if instrmnt == "ID03A"
replace instrmnt = "TP03" if instrmnt == "ID03"
replace instrmnt = "TP03" if instrmnt == ""
tab instrmnt, m

*Merging several instances of staff id 2
tab1 staffid1 staffid2
list today visitid subject if staffid2 == .
tab staffid1 staffid2
/*tab1 staffida staffidb staffidc staffidd staffide staffidf staffidg
tab staffida	staffid2
tab staffidb	staffid2
tab staffidc	staffid2
tab staffidd	staffid2
tab staffide	staffid2
tab staffidf	staffid2
tab staffidg	staffid2
replace staffid2 = staffida if staffid2 == .
replace staffid2 = staffidb if staffid2 == .
replace staffid2 = staffidc if staffid2 == .
replace staffid2 = staffidd if staffid2 == .
replace staffid2 = staffide if staffid2 == .
replace staffid2 = staffidf if staffid2 == .
replace staffid2 = staffidg if staffid2 == .
drop staffida staffidb staffidc staffidd staffide staffidf staffidg
tab staffid1 staffid2 */


*Correcting misplaced interviews not on baseline
*tab visitid, m
*tab visitid, nolab
*list today subject visitid staffid1 dur if visitid != 1

*Correcting Computer Names
tab compname
replace compname = "KSM01" if compname == "AM01"
replace compname = "KSM01" if compname == "C1"
replace compname = "KSM01" if compname == "NRB01"
replace compname = "KSM02" if compname == "AM02"
replace compname = "KSM03" if compname == "AM03"
replace compname = "KSM04" if compname == "AM04"
tab compname, m
 
//Correcting wrong visit Dates
tab visitid, m
*replace visitid = 9 if today == td(11nov2020) & subject == 31102292 & visitid == 12
replace today = td(08oct2019) if today == td(07oct2019) & subject == 31100106
replace today = td(08oct2019) if today == td(07oct2019) & subject == 31100113
replace today = td(08oct2019) if today == td(11oct2019) & subject == 31100120
replace today = td(07jan2020) if today == td(07feb2020) & subject == 31100120
replace today = td(09nov2020) if today == td(08nov2020) & subject == 31100229
replace today = td(22oct2020) if today == td(20nov2020) & subject == 31100281
replace today = td(11oct2019) if today == td(23oct2019) & subject == 31100298
replace today = td(12jul2021) if today == . 			& subject == 31100298
replace today = td(26jul2021) if today == . 			& subject == 31100380
replace today = td(13jan2020) if today == td(06mar2020) & subject == 31100526
replace today = td(30oct2020) if today == td(22nov2020) & subject == 31100526
replace today = td(06dec2020) if today == td(11dec2020) & subject == 31100618
replace today = td(06dec2020) if today == td(16dec2020) & subject == 31100649
replace today = td(06sep2021) if today == td(08sep2021) & subject == 31100649
replace today = td(10aug2021) if today == . 			& subject == 31100731
replace today = td(06dec2020) if today == td(17dec2020) & subject == 31100748
replace today = td(08dec2020) if today == td(17dec2020) & subject == 31100779
replace today = td(08sep2021) if today == td(14sep2021) & subject == 31100793
replace today = td(12sep2021) if today == td(14sep2021) & subject == 31100816
replace today = td(18dec2020) if today == td(22dec2020) & subject == 31100946
replace today = td(19dec2020) if today == td(23dec2020) & subject == 31100953
replace today = td(18dec2020) if today == td(21dec2020) & subject == 31100960

replace today = td(05feb2020) if today == td(17feb2020) & subject == 31101011
replace today = td(06nov2019) if today == td(04nov2019) & subject == 31101028
replace today = td(21mar2021) if today == td(22mar2020) & subject == 31101035
replace today = td(22mar2021) if today == td(23mar2021) & subject == 31101042
replace today = td(19dec2020) if today == td(21dec2020) & subject == 31101073
replace today = td(30oct2020) if today == td(22nov2020) & subject == 31101080
replace today = td(22mar2021) if today == td(31mar2021) & subject == 31101127
replace today = td(19dec2020) if today == td(22dec2020) & subject == 31101172
replace today = td(07feb2020) if today == td(13feb2020) & subject == 31101202
replace today = td(21oct2020) if today == td(22nov2020) & subject == 31101271
replace today = td(05jul2021) if today == td(07jul2021) & subject == 31101394
replace today = td(22oct2020) if today == td(22nov2020) & subject == 31101431
replace today = td(13oct2021) if today == . 			& subject == 31101554
replace today = td(06sep2021) if today == . 			& subject == 31101608
replace today = td(17oct2020) if today == td(23dec2020) & subject == 31101622
replace today = td(17jul2021) if today == td(23jul2021) & subject == 31101642
replace today = td(17jan2022) if today == td(18jan2022) & subject == 31101660
replace today = td(17jan2022) if today == td(18jan2022) & subject == 31101677
replace today = td(19jan2022) if today == td(20jan2022) & subject == 31101813


replace today = td(21oct2020) if today == td(23nov2020) & subject == 31102018
replace today = td(22nov2020) if today == td(25nov2020) & subject == 31102285
replace today = td(09nov2020) if today == td(23nov2020) & subject == 31102292
replace today = td(27oct2020) if today == td(24nov2020) & subject == 31102322
replace today = td(22oct2020) if today == td(23nov2020) & subject == 31102339
replace today = td(23oct2020) if today == td(23nov2020) & subject == 31102490
replace today = td(06dec2020) if today == td(22dec2020) & subject == 31102568
replace today = td(05dec2020) if today == td(17dec2020) & subject == 31102582
replace today = td(05dec2020) if today == td(18dec2020) & subject == 31102612
replace today = td(05dec2020) if today == td(21dec2020) & subject == 31102643
replace today = td(09nov2020) if today == td(08nov2020) & subject == 31102735
replace today = td(29oct2020) if today == td(24nov2020) & subject == 31102759
replace today = td(23oct2020) if today == td(02nov2020) & subject == 31102827
replace today = td(02nov2020) if today == td(23nov2020) & subject == 31102827
replace today = td(10nov2020) if today == td(09nov2020) & subject == 31102865
replace today = td(23mar2021) if today == td(01apr2021) & subject == 31102988

replace today = td(04nov2020) if today == td(23nov2020) & subject == 31103343
replace today = td(30oct2020) if today == td(23nov2020) & subject == 31103374
replace today = td(04nov2020) if today == td(23nov2020) & subject == 31103589
replace today = td(04nov2020) if today == td(23nov2020) & subject == 31103596
replace today = td(19feb2021) if today == td(24feb2021) & subject == 31100090
replace today = td(03feb2021) if today == td(02feb2021) & subject == 31102919
replace today = td(23mar2021) if today == td(26mar2021) & subject == 31103018


//Correcting wrong visit Ids
tab visitid, m
replace visitid = 24 if subject == 31100076 & today == td(21sep2021) 
replace visitid = 12 if subject == 31100618 & today == td(06dec2020)
replace visitid = 12 if subject == 31100649 & today == td(06dec2020)
replace visitid = 12 if subject == 31100748 & today == td(06dec2020)
replace visitid = 12 if subject == 31100779 & today == td(08dec2020)
replace visitid = 12 if subject == 31100960 & today == td(18dec2020)

replace visitid = 12 if subject == 31101073 & today == td(19dec2020)
replace visitid = 21 if subject == 31101325 & today == td(21sep2021)
replace visitid = 21 if subject == 31101509 & today == td(21sep2021)
replace visitid = 18 if subject == 31101554 & today == td(05jul2021)
replace visitid = 18 if subject == 31101875 & today == td(15jun2021)

replace visitid = 21 if subject == 31102179 & today == td(21sep2021)
replace visitid = 9  if subject == 31102568 & today == td(06dec2020)
replace visitid = 9  if subject == 31102582 & today == td(05dec2020)
replace visitid = 9  if subject == 31102612 & today == td(05dec2020)
replace visitid = 9  if subject == 31102643 & today == td(05dec2020)
replace visitid = 9  if subject == 31102827 & today == td(02nov2020)
replace visitid = 9  if subject == 31102926 & today == td(18dec2020)
replace visitid = 9  if subject == 31102971 & today == td(18dec2020)

replace visitid = 9  if subject == 31103121 & today == td(16dec2020)
replace visitid = 9  if subject == 31103435 & today == td(21dec2020)
replace visitid = 9  if subject == 31103466 & today == td(21dec2020)

//Correcting wrong IDs
replace subject = 31103497  if subject == 31103491 & today == td(28sep2021)


//Dropping wrong interviews
drop if subject == 31100298 & today == td(11oct2019) & visitid == 3
drop if subject == 31100526 & today == td(13jan2020) & visitid == 1
drop if subject == 31102292 & today == td(11nov2020) & visitid == 12
drop if subject == 31102322 & today == td(27oct2020) & visitid == 12
drop if subject == 31103336 & today == td(04mar2021) & visitid == 15
drop if subject == 31101127 & today == td(29mar2021) & visitid == 12
drop if subject == 31100243 & today == td(06apr2021) & visitid == 18

*Renaming Variables
rename pbi3            TP003pbi3      
rename pbi4            TP003pbi4      
rename pbi5            TP003pbi5      
rename pbi6            TP003pbi6      
rename pbi7            TP003pbi7      
rename pbi8            TP003pbi8      
rename pbi9            TP003pbi9      
rename pbi10           TP003pbi10     
rename pbi11           TP003pbi11     
rename pbi12           TP003pbi12     
rename pbi13           TP003pbi13     
rename pbi14           TP003pbi14     
rename pbi15           TP003pbi15     
rename pbi16           TP003pbi16     
rename pbi17           TP003pbi17     
rename pbi18           TP003pbi18     
rename sh1             TP003sh1       
rename sh2             TP003sh2       
rename sh3             TP003sh3       
rename sh4             TP003sh4       
rename sh5             TP003sh5       
rename sh6             TP003sh6       
rename sh7             TP003sh7       
rename sh8             TP003sh8       
rename sh9             TP003sh9       
rename sh10            TP003sh10      
rename sh11            TP003sh11      
rename ra1             TP003ra1       
rename ra2             TP003ra2       
rename ra3             TP003ra3       
rename ra4             TP003ra4       
rename ra5             TP003ra5       
rename ra6             TP003ra6       
rename ra7             TP003ra7       
rename ra8             TP003ra8       
rename ra9             TP003ra9       
rename ra10            TP003ra10      
rename ra11            TP003ra11      
rename ra12            TP003ra12      
rename ra13            TP003ra13      
rename ra14            TP003ra14      
rename ra15            TP003ra15      
rename ra16            TP003ra16      
rename ra17            TP003ra17      
rename ra18            TP003ra18      
rename ra19            TP003ra19      
rename ra20            TP003ra20      
rename ra21            TP003ra21      
rename ra22            TP003ra22      
rename ra23            TP003ra23      
rename ra24            TP003ra24      
rename ra25            TP003ra25      
rename ra26            TP003ra26      
rename ra27            TP003ra27      
rename ra28            TP003ra28      
rename ra29            TP003ra29      
rename ra30            TP003ra30      
rename ra31            TP003ra31      
rename ra32            TP003ra32      
rename ra33            TP003ra33      
rename ra34            TP003ra34      
rename ra35            TP003ra35      
rename ra36            TP003ra36      
rename ra37            TP003ra37      
rename ra38            TP003ra38      
rename ra39            TP003ra39      
rename ra40            TP003ra40      
rename ra41            TP003ra41      
rename ra42            TP003ra42      
rename ra43            TP003ra43      
rename ra44            TP003ra44      
rename ra45            TP003ra45      
rename ra46            TP003ra46      
rename ra47            TP003ra47      
rename ra48            TP003ra48      
rename ra49            TP003ra49      
rename ra50            TP003ra50      
rename ra51            TP003ra51      
rename ipv1            TP003ipv1      
rename ipv2            TP003ipv2      
rename ipv3            TP003ipv3      
rename ipv4            TP003ipv4      
rename ipv5            TP003ipv5      
rename phq1            TP003phq1      
rename phq2            TP003phq2      
rename phq3            TP003phq3      
rename phq4            TP003phq4      
rename phq5            TP003phq5      
rename phq6            TP003phq6      
rename phq7            TP003phq7      
rename phq8            TP003phq8      
rename phq9            TP003phq9      
rename phq10           TP003phq10     
rename aud1            TP003aud1      
rename aud2            TP003aud2      
rename aud3            TP003aud3      
rename aud4            TP003aud4      
rename aud5            TP003aud5      
rename aud6            TP003aud6      
rename aud7            TP003aud7      
rename aud8            TP003aud8      
rename aud9            TP003aud9      
rename aud10           TP003aud10     
rename das1            TP003das1      
rename das2            TP003das2      
rename das3            TP003das3      
rename das4            TP003das4      
rename das5            TP003das5      
rename das6            TP003das6      
rename das7            TP003das7      
rename das8            TP003das8      
rename das9            TP003das9      
rename das10           TP003das10     
rename das11           TP003das11     
rename das12           TP003das12     
rename cas1            TP003cas1      
rename cas2            TP003cas2      
rename cas3            TP003cas3      
rename cas4            TP003cas4      
rename sst1            TP003sst1      
rename sst2            TP003sst2      
rename sst3            TP003sst3      
rename sst4            TP003sst4      
rename sst5            TP003sst5      
rename sst6            TP003sst6      
rename sst7            TP003sst7      
rename sst8            TP003sst8      
rename sst9            TP003sst9      
rename sst10           TP003sst10     
rename sst11           TP003sst11     
rename sha1            TP003sha1      
rename hri1            TP003hri1      
rename pku1            TP003pku1      
rename pku2            TP003pku2      
rename pku3            TP003pku3      
rename pku4            TP003pku4      
rename pku5            TP003pku5      
rename pku6            TP003pku6      
rename pku7            TP003pku7      
rename pcu1            TP003pcu1      
rename pcu2            TP003pcu2      
rename pcu3            TP003pcu3      
rename pcu4            TP003pcu4      
rename paq1            TP003paq1      
rename paq2            TP003paq2      
rename paq3            TP003paq3      
rename paq4            TP003paq4      
rename paq5            TP003paq5      
rename paq6            TP003paq6      
rename paq7            TP003paq7      
rename paq8            TP003paq8      
rename paq9            TP003paq9      
rename paq10           TP003paq10     
rename paq11           TP003paq11     
rename snq1            TP003snq1      
rename snq2            TP003snq2      
rename snq3            TP003snq3      
rename snq4            TP003snq4      
rename snq5            TP003snq5      
rename snq6            TP003snq6      
rename snq7            TP003snq7      
rename gat1            TP003gat1      
rename gat2            TP003gat2      
rename gat3            TP003gat3      
rename gat4            TP003gat4      

//CHECKING FOR DUPLICATES
sort today subject visitid   
quietly by today subject visitid: gen dup = cond(_N==1,0,_n)
tab dup
list today subject visitid site staffid1 compname if dup > 0
count if dup >= 2
drop if dup >= 2
drop dup

*Housekeeping and saving
order staffid1 today subject instrmnt compname intlang site visitid age ///
TP003pbi3 TP003pbi4  
sort visitid today subject 
compress

*Saving all
save TTP003Final, replace
count
tab visitid, m

*Saving Baseline 
drop if visitid != 1
count
save TTP003Baseline, replace

*Saving Month3 Follow ups
clear
use TTP003Final
count
drop if visitid != 3
count
save TTP003M3, replace

*Saving Month 6 Follow ups
clear
use TTP003Final
count
drop if visitid != 6
count
save TTP003M6, replace

*Saving Month 9 Follow ups
clear
use TTP003Final
count
drop if visitid != 9
count
save TTP003M9, replace

*Saving Month 12 Follow ups
clear
use TTP003Final
count
drop if visitid != 12
count
save TTP003M12, replace

*Saving Month 15 Follow ups
clear
use TTP003Final
drop if visitid != 15
count
save TTP003M15, replace

*Saving Month 18 Follow ups
clear
use TTP003Final
drop if visitid != 18
count
save TTP003M18, replace

*Saving Month 21 Follow ups
clear
use TTP003Final
drop if visitid != 21
count
save TTP003M21, replace

*Saving Month 24 Follow ups
clear
use TTP003Final
drop if visitid != 24
count
save TTP003M24, replace

*Saving Month 27 Follow ups
clear
use TTP003Final
drop if visitid != 27
count
save TTP003M27, replace


clear

*END*

