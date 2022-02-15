*********************************************************************************
*	Project:		TATU PAMOJA			   					 					*
*	Description :	Cleaning and fixing of errors for the Medical Form004		*	
*	Date created:	December 14, 2021                                            *
*	Programer: 		Omolo, Ronald                               	         	*
*	Date modified:	                                           					*
*	Mdified by:																	*
*	STATA Ver:  	14.2                                                     	*
********************************************************************************* 
		
cd "\\NRHS-RTI01\Study Documents\TTP\Data\Clean Data"
clear

// IMPORTING CAPI Medical DATA
***********************************
*Baseline
use "\\NRHS-RTI01\Study Documents\TTP\Data\Raw Data\STATA\TTP004"
count
br

*Dropping wrong Interviews
tab subjects, m
tab subjectt, m
drop if subjectt == . & subjects == . & pmh1 == .
rename subjectt  subject
list subject subjects if subject == 99999999
replace subject = subjects if subject == 99999999 & subjects != 999999
sort subject

*Destring variables
destring staffid1 staffid2, replace

*Separating Study Specific ACASI
tab study, m
tab study, nolab m
list subject subjects study if study == 2
list subject subjects study if study == 1
list subject subjects study if study == .

replace study = 1 if subject >= 31100011 & subject <= 33000000
replace study = 2 if subject >= 500011 & subject <= 610000
tab study, m

*Saving all
compress
save MED004FinalAll, replace
count 

*Separating Study Specific Medical
tab study, m
tab study, nolab
list subject subjects if study == .

*TTP
keep if study == 1
count
drop subjects pids visitids 
rename pidt			pid
rename visitidt		visitid
order staffid1 today subject visitid study
sort subject today
compress
count
save TTP004FinalAll, replace
clear

*Shauriana
use MED004FinalAll
keep if study == 2
count
drop subjects pidt visitidt
rename pids			pid
rename visitids		visitid
order staffid1 today subject visitid study 
sort  subject today 
compress
count
save SHA004FinalAll, replace
clear

*Data Management of TTP
use TTP004FinalAll
count
br

*Standardising Visit ID     
tab visitid
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
list subject pid visitid if visitid == 99
tab visitid, m

*Standardise Instrument Names
tab instrmnt, m
replace instrmnt = "TP04" if instrmnt == "ID04"
replace instrmnt = "TP04" if instrmnt == "004"
tab instrmnt, m

*Correcting Interview Dates to Allow for Merging
replace today = td(19feb2021) if today == td(24feb2021) & subject == 31100090
replace today = td(22oct2020) if today == td(20nov2020) & subject == 31100168
replace today = td(22oct2020) if today == td(20nov2020) & subject == 31100243
replace today = td(21oct2020) if today == td(20nov2020) & subject == 31100250
replace today = td(21oct2020) if today == td(20nov2020) & subject == 31100274
replace today = td(22oct2020) if today == td(20nov2020) & subject == 31100281
replace today = td(23oct2020) if today == td(20nov2020) & subject == 31100410
replace today = td(22oct2020) if today == td(23nov2020) & subject == 31100441
replace today = td(23oct2020) if today == td(23nov2020) & subject == 31100502
replace today = td(13jan2020) if today == td(06mar2020) & subject == 31100526
replace today = td(17nov2020) if today == td(24nov2020) & subject == 31100588
replace today = td(06dec2020) if today == td(11dec2020) & subject == 31100618
replace today = td(11aug2021) if today == td(10nov2021) & subject == 31100618 & visitid == 21
replace today = td(06dec2020) if today == td(16dec2020) & subject == 31100649
replace today = td(06sep2021) if today == td(08sep2021) & subject == 31100649
replace today = td(10aug2021) if today == td(10nov2021) & subject == 31100731
replace today = td(06dec2020) if today == td(17dec2020) & subject == 31100748
replace today = td(08dec2020) if today == td(17dec2020) & subject == 31100779
replace today = td(08sep2021) if today == td(14sep2021) & subject == 31100793
replace today = td(27oct2020) if today == td(23nov2020) & subject == 31100809
replace today = td(12sep2021) if today == td(14sep2021) & subject == 31100816
replace today = td(22oct2020) if today == td(23nov2020) & subject == 31100830
replace today = td(21oct2020) if today == td(23nov2020) & subject == 31100892
replace today = td(18dec2020) if today == td(22dec2020) & subject == 31100946
replace today = td(19dec2020) if today == td(23dec2020) & subject == 31100953
replace today = td(18dec2020) if today == td(21dec2020) & subject == 31100960

replace today = td(21mar2021) if today == td(22mar2020) & subject == 31101035
replace today = td(19dec2020) if today == td(21dec2020) & subject == 31101073
replace today = td(22mar2021) if today == td(23mar2021) & subject == 31101042
replace today = td(19dec2020) if today == td(22dec2020) & subject == 31101172
replace today = td(22mar2021) if today == td(29mar2021) & subject == 31101127
replace today = td(27oct2020) if today == td(23nov2020) & subject == 31101134
replace today = td(26oct2020) if today == td(23nov2020) & subject == 31101158
replace today = td(21oct2020) if today == td(23nov2020) & subject == 31101271
replace today = td(26oct2020) if today == td(23nov2020) & subject == 31101370
replace today = td(05jul2021) if today == td(07jul2021) & subject == 31101394
replace today = td(22oct2020) if today == td(23nov2020) & subject == 31101431
replace today = td(23oct2020) if today == td(23nov2020) & subject == 31101486
replace today = td(26oct2020) if today == td(23nov2020) & subject == 31101547
replace today = td(25feb2020) if today == td(26feb2020) & subject == 31101585
replace today = td(26oct2020) if today == td(23nov2020) & subject == 31101585
replace today = td(17oct2020) if today == td(23dec2020) & subject == 31101622
replace today = td(17jul2021) if today == td(23jul2021) & subject == 31101642
replace today = td(17jan2022) if today == td(18jan2022) & subject == 31101660
replace today = td(21oct2020) if today == td(23nov2020) & subject == 31101707
replace today = td(27oct2020) if today == td(23nov2020) & subject == 31101738

replace today = td(21oct2020) if today == td(23nov2020) & subject == 31102018
replace today = td(22nov2020) if today == td(25nov2020) & subject == 31102285
replace today = td(09nov2020) if today == td(11nov2020) & subject == 31102292
replace today = td(27oct2020) if today == td(23nov2020) & subject == 31102308
replace today = td(26oct2020) if today == td(23nov2020) & subject == 31102315
replace today = td(27oct2020) if today == td(23nov2020) & subject == 31102322
replace today = td(22oct2020) if today == td(23nov2020) & subject == 31102339
replace today = td(23oct2020) if today == td(23nov2020) & subject == 31102490
replace today = td(23oct2020) if today == td(23nov2020) & subject == 31102506
replace today = td(06dec2020) if today == td(22dec2020) & subject == 31102568
replace today = td(05dec2020) if today == td(17dec2020) & subject == 31102582
replace today = td(05dec2020) if today == td(18dec2020) & subject == 31102612
replace today = td(05dec2020) if today == td(21dec2020) & subject == 31102643
replace today = td(27jan2020) if today == td(28jan2020) & subject == 31102667
replace today = td(15dec2020) if today == td(22dec2020) & subject == 31102773
replace today = td(22oct2021) if today == td(10nov2021) & subject == 31102759 & visitid == 21
replace today = td(23mar2021) if today == td(01apr2021) & subject == 31102988

replace today = td(17dec2020) if today == td(18dec2020) & subject == 31103107
replace today = td(02nov2020) if today == td(24nov2020) & subject == 31103183



*Correcting Visit ID to Allow for Merging
list today subject visitid if subject == 31101028

replace visitid = 12 if subject == 31100618 & today == td(06dec2020)
replace visitid = 12 if subject == 31100649 & today == td(06dec2020)
replace visitid = 12 if subject == 31100748 & today == td(06dec2020)
replace visitid = 12 if subject == 31100779 & today == td(08dec2020)
replace visitid = 12 if subject == 31100960 & today == td(18dec2020)

replace visitid = 3  if subject == 31101028 & today == td(07feb2020)
replace visitid = 12 if subject == 31101073 & today == td(19dec2020)
replace visitid = 15 if subject == 31101127 & today == td(22mar2021)
replace visitid = 15 if subject == 31102445 & today == td(13may2021)

replace visitid = 9  if subject == 31102568 & today == td(06dec2020)
replace visitid = 9  if subject == 31102582 & today == td(05dec2020)
replace visitid = 9  if subject == 31102612 & today == td(05dec2020)
replace visitid = 9  if subject == 31102643 & today == td(05dec2020)
replace visitid = 9  if subject == 31102582 & today == td(05dec2020)
replace visitid = 9  if subject == 31102827 & today == td(02nov2020)
replace visitid = 9  if subject == 31102926 & today == td(18dec2020)
replace visitid = 9  if subject == 31102971 & today == td(18dec2020)

replace visitid = 1  if subject == 31103114 & today == td(12feb2020)
replace visitid = 9  if subject == 31103121 & today == td(16dec2020)
replace visitid = 12 if subject == 31103336 & today == td(04mar2021)
replace visitid = 12 if subject == 31103350 & today == td(19mar2021)
replace visitid = 12 if subject == 31103367 & today == td(19mar2021)


*Replacing PIDs
replace subject = 31100489 if subject == 31100486 & today ==td(8feb2021)
replace pid = 31100489 if pid == 31100486 & today ==td(8feb2021)

*Replacing Interview time
replace start = tc(14:54::00) if subject ==31102391 & today ==td(27apr2021)
replace endtime = tc(14:57::00) if subject == 31102391 & today ==td(27apr2021)

*Dropping wrong interviews
drop if subject == 31100076 & today == td(25aug2021)
drop if subject == 31102759 & today == td(22oct2021) & visitid == 24
drop if subject == 31100984 & today == td(07feb2020) & visitid == 1


*Renaming Variables
rename pmh1            TP004pmh1     
rename pmh2            TP004pmh2     
rename pmh3            TP004pmh3     
rename pmh4            TP004pmh4     
rename pmh5            TP004pmh5     
rename pmh6            TP004pmh6     
rename pmh7            TP004pmh7     
rename pmh8            TP004pmh8     
rename pmh9            TP004pmh9     
rename pmh10           TP004pmh10    
rename pmh11           TP004pmh11    
rename pmh12           TP004pmh12    
rename pmh13           TP004pmh13    
rename pmh14           TP004pmh14    
rename pmh15           TP004pmh15    
rename pmh16           TP004pmh16    
rename pmh17           TP004pmh17    
rename pmh18           TP004pmh18    
rename pmh19           TP004pmh19    
rename pmh20           TP004pmh20    
rename pmh21           TP004pmh21    
rename pmh22           TP004pmh22    
rename pmh23           TP004pmh23    
rename pmh24           TP004pmh24    
rename pmh25           TP004pmh25    
rename pmh26           TP004pmh26    
rename pmh27           TP004pmh27    
rename pmh28           TP004pmh28    
rename a29             TP004a29      
rename pmh30           TP004pmh30    
rename pmh31           TP004pmh31    
rename as1             TP004as1      
rename as2             TP004as2      
rename as3             TP004as3      
rename as4             TP004as4      
rename as5             TP004as5      
rename as6             TP004as6      
rename as7             TP004as7      
rename as8             TP004as8      
rename gs1             TP004gs1      
rename gs2             TP004gs2      
rename gs3             TP004gs3      
rename gs4             TP004gs4      
rename gs5             TP004gs5      
rename c6              TP004c6       
rename ehd1            TP004ehd1     
rename ehd2            TP004ehd2     
rename ehd4            TP004ehd4     
rename ehd5            TP004ehd5     
rename ehd6            TP004ehd6     
rename ehd7            TP004ehd7     
rename ehd8            TP004ehd8     
rename ehd9            TP004ehd9     
rename ehd10           TP004ehd10    
rename ehd11           TP004ehd11    
rename ehd12           TP004ehd12    
rename ehd13           TP004ehd13    
rename ehd14           TP004ehd14    
rename ehd15           TP004ehd15    
rename ge1             TP004ge1      
rename ge2             TP004ge2      
rename ge3             TP004ge3      
rename ge4             TP004ge4      
rename ge5             TP004ge5      
rename ge6             TP004ge6      
rename ge7             TP004ge7      
rename ge8             TP004ge8      
rename ge9             TP004ge9      
rename ge10            TP004ge10     
rename ge11            TP004ge11     
rename ge12            TP004ge12     
rename ge13            TP004ge13     
rename ge14            TP004ge14     
rename ge15            TP004ge15     
rename ge16            TP004ge16     
rename ge17            TP004ge17     
rename ge18            TP004ge18     
rename ge19            TP004ge19     
rename ge20            TP004ge20     
rename ge21            TP004ge21     
rename ge22            TP004ge22     
rename ge23            TP004ge23     
rename ge24            TP004ge24     
rename ge25            TP004ge25     
rename ge26            TP004ge26     
rename ge27            TP004ge27     
rename ge28            TP004ge28     
rename ge29            TP004ge29     
rename ge30            TP004ge30     
rename ge31            TP004ge31     
rename ge32            TP004ge32     
rename ge33            TP004ge33     
rename ge34            TP004ge34     
rename ge35            TP004ge35     
rename ge36            TP004ge36     
rename inv1            TP004inv1     
rename inv2            TP004inv2     
rename inv3            TP004inv3     
rename inv4            TP004inv4     
rename inv5            TP004inv5     
rename inv6            TP004inv6     
rename inv7            TP004inv7     
rename inv8            TP004inv8     
rename ss1             TP004ss1      
rename ss2             TP004ss2      
rename ss3             TP004ss3      
rename dp1             TP004dp1      
rename dp2             TP004dp2      
rename dp3             TP004dp3      
rename dp4             TP004dp4      
rename dp5             TP004dp5      
rename dp6             TP004dp6      
rename dp7             TP004dp7      
rename dp8             TP004dp8      
rename dp9             TP004dp9      
rename dp10            TP004dp10     
rename dp11            TP004dp11     
rename dp12            TP004dp12     
rename dp13            TP004dp13     
rename dp14            TP004dp14     
rename dp15            TP004dp15     
rename dp16            TP004dp16     
rename dp17            TP004dp17     
rename dp18            TP004dp18     
rename dp19            TP004dp19     
rename dp20            TP004dp20     
rename clinotes        TP004clinotes 
rename clinarr         TP004clinarr  

//Laboratory Investigation
tab inv2a
list today subject visitid TP004inv1 TP004inv1 inv2a if inv2a == 1

//Prescriptions
tab1 TP004dp14 TP004dp16 TP004dp18 TP004dp20

*Housekeeping and saving
drop if today == . & subject == . & visitid == .
order today subject visitid staffid1 
sort visitid today subject 
compress

 //CHECKING FOR DUPLICATES
sort today subject visitid    
quietly by today subject visitid: gen dup = cond(_N==1,0,_n)
tab dup
list today subject visitid study staffid1 compname if dup > 0
count if dup == 2 | dup == 3
drop if dup >= 2
drop dup

*Saving all
save TTP004Final, replace
count

*Saving Baseline 
drop if visitid != 1
count
save TTP004Baseline, replace

*Saving Month3 Follow ups
clear
use TTP004Final
count
drop if visitid != 3
count
save TTP004M3, replace

*Saving Month 6 Follow ups
clear
use TTP004Final
count
drop if visitid != 6
count
save TTP004M6, replace

*Saving Month 9 Follow ups
clear
use TTP004Final
count
drop if visitid != 9
count
save TTP004M9, replace

*Saving Month 12 Follow ups
clear
use TTP004Final
count
drop if visitid != 12
count
save TTP004M12, replace

*Saving Month 15 Follow ups
clear
use TTP004Final
drop if visitid != 15
count
save TTP004M15, replace

*Saving Month 18 Follow ups
clear
use TTP004Final
drop if visitid != 18
count
save TTP004M18, replace

*Saving Month 21 Follow ups
clear
use TTP004Final
drop if visitid != 21
count
save TTP004M21, replace

*Saving Month 24 Follow ups
clear
use TTP004Final
drop if visitid != 24
count
save TTP004M24, replace

*Saving Month 27 Follow ups
clear
use TTP004Final
drop if visitid != 27
count
save TTP004M27, replace

clear



*END*

