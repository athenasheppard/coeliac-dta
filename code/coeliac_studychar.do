************************************************************************
** Name: coeliac_studychar.do                                         **
** Purpose: Summarise study characteristics and risk of bias          **
**          assessments                                               **
** Creator: Athena L Sheppard                                         **
** Contact: als75@leicester.ac.uk                                     **
** Stata version 16.0 (Created 17 May 2021)                           **
************************************************************************


* Set working directory
cd "D:\Coeliac DTA review\Stata\Data"


* Import study characteristic data from Excel
import excel using "qry_studychar", firstrow clear
* One row of data per study (n=113)
* Where studies reported seperate accuracy data for adults and children (n=3),
* results were extracted as two distinct sets of data


* Summarise age groups
tab Adult_child, missing


* Summarise age of patients, stratified by age group
sum Age_mean if Adult_child == "Adults" // adults
sum Age_mean if Adult_child == "Children" // children
sum Age_mean if Adult_child == "Mixed" // mixed
sum Age_mean if Adult_child == "Not specified" // not specified

sum Age_sd if Adult_child == "Adults" // adults
sum Age_sd if Adult_child == "Children" // children
sum Age_sd if Adult_child == "Mixed" // mixed
sum Age_sd if Adult_child == "Not specified" // not specified

sum Age_rangelow if Adult_child == "Adults" // adults
sum Age_rangelow if Adult_child == "Children" // children
sum Age_rangelow if Adult_child == "Mixed" // mixed
sum Age_rangelow if Adult_child == "Not specified" // not specified

sum Age_rangehigh if Adult_child == "Adults" // adults
sum Age_rangehigh if Adult_child == "Children" // children
sum Age_rangehigh if Adult_child == "Mixed" // mixed
sum Age_rangehigh if Adult_child == "Not specified" // not specified


* Summarise sex, stratified by age group
sum Sex if Adult_child == "Adults" // adults
sum Sex if Adult_child == "Children" // children
sum Sex if Adult_child == "Mixed" // mixed
sum Sex if Adult_child == "Not specified" // not specified


* Summarise other study characteristics
duplicates drop RefID, force // keep one observation per study
tab pubyear, missing // publication year
tab Country, missing // country of study
tab Data_coll, missing // data collection method
tab Symptomatic, missing // reason for biopsy
tab Ref_threshold, missing // biopsy threshold
tab Time_frame, missing // time frame between tests


* Import all data from Excel
import excel using "qry_dta", firstrow clear
* One row per set of 2x2 data (n=203)


* Summarise test types
tab Biomarker Adult_child, missing


* Risk of bias assessment
* Overall risk of bias
gen ROB = "Unclear"
replace ROB = "Low" if QUADAS_patientbias == "Low" & QUADAS_ref_bias == "Low" & QUADAS_index_bias == "Low" & QUADAS_flow_bias == "Low"
replace ROB = "High" if QUADAS_patientbias == "High" | QUADAS_ref_bias == "High" | QUADAS_index_bias == "High" | QUADAS_flow_bias == "High"
tab ROB, missing

* Patient selection
tab QUADAS_patientbias
tab QUADAS_patientbias if ROB == "Unclear"

* Index test
tab QUADAS_index_bias
tab QUADAS_index_bias if ROB == "Unclear"

* Reference standard
tab QUADAS_ref_bias
tab QUADAS_ref_bias if ROB == "Unclear"

* Flow and timing
tab QUADAS_flow_bias
tab QUADAS_flow_bias if ROB == "Unclear"
tab QUADAS_flow_ref // potential for partial verification bias