************************************************************************
** Name: coeliac_allthresholds.do                                     **
** Purpose: Summarise study test accuracy (Table 1)                   **
** Creator: Athena L Sheppard                                         **
** Contact: 2138248@swansea.ac.uk                                     **
** Stata version 16.0 (Created 17 May 2021)                           **
************************************************************************


* Set working directory
cd "D:\Coeliac DTA review\Stata\Data"


* Import all data from Excel
import excel using "qry_dta", firstrow clear


* Calculate total number of patients
gen total = TP + FP + FN + TN // number of patients per set of 2x2 data
bysort Adult_child_res Biomarker: egen n=total(total) // number of patients, stratified by age group and test


* Calculate number of patients with coeliac disease
gen cd = TP + FN // number of patients per set of 2x2 data
bysort Adult_child_res Biomarker: egen n_cd=total(cd) // number of patients, stratified by age group and test


* Calculate coeliac disease prevalence
gen prev = (  cd / total ) * 100
summarize prev // summarise coeliac disease prevalence


* Calculate sensitivity and specificity
gen sens = ( TP / ( TP + FN ) ) * 100
gen spec = ( TN / ( TN + FP ) ) * 100


* Adults
* IgA tTG
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-tTG", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"

* IgG tTG
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgG-tTG", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgG-tTG"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgG-tTG"

* IgA EMA
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-EMA", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"

* IgG EMA
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgG-EMA", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgG-EMA"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgG-EMA"

* IgA DGP
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-DGP", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-DGP"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-DGP"

* IgG DGP
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgG-DGP", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgG-DGP"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgG-DGP"

* IgA/IgG DGP
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-DGP", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-DGP"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-DGP"

* IgA/IgG tTG/DGP
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-tTG/DGP", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-tTG/DGP"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-tTG/DGP"

* IgA AAA
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-AAA", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-AAA"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-AAA"


* Children
* IgA tTG
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-tTG", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-tTG"

* IgG tTG
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgG-tTG", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgG-tTG"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgG-tTG"

* IgA/IgG tTG
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA/IgG-tTG", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA/IgG-tTG"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA/IgG-tTG"

* IgA EMA
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-EMA", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-EMA"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-EMA"

* IgA/IgG EMA
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA/IgG-EMA", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA/IgG-EMA"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA/IgG-EMA"

* IgA DGP
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-DGP", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-DGP"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-DGP"

* IgG DGP
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgG-DGP", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgG-DGP"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgG-DGP"

* IgA/IgG DGP
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA/IgG-DGP", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA/IgG-DGP"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA/IgG-DGP"

* IgA/IgG tTG/DGP
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA/IgG-tTG/DGP", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA/IgG-tTG/DGP"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA/IgG-tTG/DGP"


* Mixed or age unspecified
replace Adult_child_res = "Other" if Adult_child_res == "Mixed" | ///
		Adult_child_res == "Not specified" // combine other age groups

* IgA tTG
tab Index_threshold if Adult_child_res == "Other" && Biomarker == "IgA-tTG", missing
summarize sens if Adult_child_res == "Other" && Biomarker == "IgA-tTG"
summarize spec if Adult_child_res == "Other" && Biomarker == "IgA-tTG"

* IgG tTG
tab Index_threshold if Adult_child_res == "Other" && Biomarker == "IgG-tTG", missing
summarize sens if Adult_child_res == "Other" && Biomarker == "IgG-tTG"
summarize spec if Adult_child_res == "Other" && Biomarker == "IgG-tTG"

* IgA/IgG tTG
tab Index_threshold if Adult_child_res == "Other" && Biomarker == "IgA/IgG-tTG", missing
summarize sens if Adult_child_res == "Other" && Biomarker == "IgA/IgG-tTG"
summarize spec if Adult_child_res == "Other" && Biomarker == "IgA/IgG-tTG"

* IgA EMA
tab Index_threshold if Adult_child_res == "Other" && Biomarker == "IgA-EMA", missing
summarize sens if Adult_child_res == "Other" && Biomarker == "IgA-EMA"
summarize spec if Adult_child_res == "Other" && Biomarker == "IgA-EMA"

* IgA DGP
tab Index_threshold if Adult_child_res == "Other" && Biomarker == "IgA-DGP", missing
summarize sens if Adult_child_res == "Other" && Biomarker == "IgA-DGP"
summarize spec if Adult_child_res == "Other" && Biomarker == "IgA-DGP"

* IgG DGP
tab Index_threshold if Adult_child_res == "Other" && Biomarker == "IgG-DGP", missing
summarize sens if Adult_child_res == "Other" && Biomarker == "IgG-DGP"
summarize spec if Adult_child_res == "Other" && Biomarker == "IgG-DGP"

* IgA/IgG DGP
tab Index_threshold if Adult_child_res == "Other" && Biomarker == "IgA/IgG-DGP", missing
summarize sens if Adult_child_res == "Other" && Biomarker == "IgA/IgG-DGP"
summarize spec if Adult_child_res == "Other" && Biomarker == "IgA/IgG-DGP"

* IgA AAA
tab Index_threshold if Adult_child_res == "Other" && Biomarker == "IgA-AAA", missing
summarize sens if Adult_child_res == "Other" && Biomarker == "IgA-AAA"
summarize spec if Adult_child_res == "Other" && Biomarker == "IgA-AAA"


* Display total number of patients and number of patients with coeliac disease,
* stratified by age group and test
duplicates drop Adult_child_res Biomarker, force // keep one observation per age and test combination
list Adult_child_res Biomarker n n_cd // display counts