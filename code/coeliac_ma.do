************************************************************************
** Name: coeliac_ma.do                                                **
** Purpose: Meta-analyse accuracy data (Table 2, Figures 2, 3 & 4)    **
** Creator: Athena L Sheppard                                         **
** Contact: als75@leicester.ac.uk                                     **
** Stata version 16.0 (Created 17 May 2021)                           **
************************************************************************


* Set working directory
cd "D:\Coeliac DTA review\Stata\Data"


* Import all data from Excel
import excel using "qry_dta", firstrow clear


* Calculate total number of patients
gen total = TP + FP + FN + TN // number of patients per set of 2x2 data


* Calculate number of patients with coeliac disease
gen cd = TP + FN // number of patients per set of 2x2 data


* Calculate sensitivity and specificity
gen sens = TP / ( TP + FN )
gen spec = TN / ( TN + FP )


* Calculate positive and negative predictive values
gen ppv = TP / ( TP + FP )
gen npv = TN / ( TN + FN )


* Risk of bias assessment
* Overall risk of bias
gen ROB = "Unclear"
replace ROB = "Low" if QUADAS_patientbias == "Low" & QUADAS_ref_bias == "Low" & QUADAS_index_bias == "Low" & QUADAS_flow_bias == "Low"
replace ROB = "High" if QUADAS_patientbias == "High" | QUADAS_ref_bias == "High" | QUADAS_index_bias == "High" | QUADAS_flow_bias == "High"
tab ROB, missing


* Save data
save ma_data, replace


* Note: Run metandi.ado before analysis; includes option for univariate fixed
*       effects meta-analysis where there are few (2-3) studies in a data set


* Adults
* IgA tTG
* Meta-analysis, most commonly reported threshold
metandi TP FP FN TN if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" && Index_threshold == "15 U/mL", gllamm
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 1334 91 // ppv confidence interval
cii proportions 8666 8657 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "15 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 15 U/mL threshold" 8 "Study estimate, 15 U/mL threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9065 0.8744, m(diamond) mc(black) msiz(small) || ///
	pci 0.9065 0.8439 0.9065 0.8997, lc(black) || ///
	pci 0.8734 0.8744 0.9317 0.8744, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgA EMA
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi TP FP FN TN if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" && Index_threshold == "1:5"
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 127 88 // ppv confidence interval
cii proportions 9873 9861 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "1:5") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 1:5 threshold" 8 "Study estimate, 1:5 threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.8801 0.9961, m(diamond) mc(black) msiz(small) || ///
	pci 0.8801 0.9235 0.8801 0.9998, lc(black) || ///
	pci 0.7520 0.9961 0.9467 0.9961, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgA DGP
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi2 TP FP FN TN if Adult_child_res == "Adults" && Biomarker == "IgA-DGP" && Index_threshold == "20 U/mL", u
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 547 96 // ppv confidence interval
cii proportions 9453 9449 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "20 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Adults" && Biomarker == "IgA-DGP"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi2 TP FP FN TN if spec != ., u
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 1:5 threshold" 8 "Study estimate, 1:5 threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9643 0.9544, m(diamond) mc(black) msiz(small) || ///
	pci 0.9643 0.9359 0.9643 0.9678, lc(black) || ///
	pci 0.9171 0.9544 0.9851 0.9544, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgG DGP
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi2 TP FP FN TN if Adult_child_res == "Adults" && Biomarker == "IgG-DGP" && Index_threshold == "20 U/mL", u
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 158 94 // ppv confidence interval
cii proportions 9842 9836 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "20 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Adults" && Biomarker == "IgG-DGP"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 20 U/mL threshold" 8 "Study estimate, 20 U/mL threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9364 0.9936, m(diamond) mc(black) msiz(small) || ///
	pci 0.9364 0.9847 0.9364 0.9973, lc(black) || ///
	pci 0.8865 0.9936 0.9652 0.9936, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgA/IgG DGP
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi TP FP FN TN if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-DGP" && Index_threshold == "20 U/mL", gllamm
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 418 91 // ppv confidence interval
cii proportions 9582 9573 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "20 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-DGP"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
metandi TP FP FN TN, gllamm // meta-analysis across all thresholds
metandiplot TP FP FN TN, ///
	summopts(off) curveopts(off) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(3 "Summary point, 20 U/mL threshold" 6 "Study estimate, 20 U/mL threshold")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9149 0.9670, m(diamond) mc(black) msiz(small) || ///
	pci 0.9149 0.9525 0.9149 0.9772, lc(black) || ///
	pci 0.8471 0.9670 0.9543 0.9670, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70))


* IgA/IgG tTG/DGP
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi2 TP FP FN TN if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-tTG/DGP" && Index_threshold == "20 U/mL", u
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 1448 94 // ppv confidence interval
cii proportions 8552 8546 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "20 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-tTG/DGP"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi2 TP FP FN TN if spec != ., u // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 1:5 threshold" 8 "Study estimate, 1:5 threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9355 0.8632, m(diamond) mc(black) msiz(small) || ///
	pci 0.9355 0.7970 0.9355 0.9104, lc(black) || ///
	pci 0.8843 0.8632 0.9649 0.8632, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgA AAA
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi2 TP FP FN TN if Adult_child_res == "Adults" && Biomarker == "IgA-AAA" && Index_threshold == "25 U/mL", u
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 825 83 // ppv confidence interval
cii proportions 9175 9158 // npv confidence interval
gen common_thresh = (Index_threshold == "25 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Adults" && Biomarker == "IgA-AAA"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease


* Children
* IgA tTG
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi TP FP FN TN if Adult_child_res == "Children" && Biomarker == "IgA-tTG" && Index_threshold == "20 U/mL"
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 3049 98 // ppv confidence interval
cii proportions 6951 6949 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "20 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 20 U/mL threshold" 8 "Study estimate, 20 U/mL threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9769 0.7019, m(diamond) mc(black) msiz(small) || ///
	pci 0.9769 0.3927 0.9769 0.8955, lc(black) || ///
	pci 0.9098 0.7019 0.9944 0.7019, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgG tTG
use ma_data, clear
* Summary ROC plot
keep if Adult_child_res == "Children" && Biomarker == "IgG-tTG"
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
metandi TP FP FN TN // meta-analysis across all thresholds
metandiplot TP FP FN TN, ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(4 "Study estimate, any threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight], m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgA EMA
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi TP FP FN TN if Adult_child_res == "Children" && Biomarker == "IgA-EMA" && Index_threshold == "1:10", gllamm
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 708 94 // ppv confidence interval
cii proportions 9292 9286 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "1:10") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Children" && Biomarker == "IgA-EMA"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 1:10 threshold" 8 "Study estimate, 1:10 threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9448 0.9380, m(diamond) mc(black) msiz(small) || ///
	pci 0.9448 0.8521 0.9448 0.9755, lc(black) || ///
	pci 0.8887 0.9380 0.9734 0.9380, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgG DGP
use ma_data, clear
* Summary ROC plot
metandi2 TP FP FN TN if Adult_child_res == "Children" && Biomarker == "IgG-DGP", u // meta-analysis across all thresholds
keep if Adult_child_res == "Children" && Biomarker == "IgG-DGP"
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
metandiplot TP FP FN TN, ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(4 "Study estimate, any threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight], m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgA/IgG DGP
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi TP FP FN TN if Adult_child_res == "Children" && Biomarker == "IgA/IgG-DGP" && Index_threshold == "20 U/mL"
* Positive and negative predictive values and natural frequencies
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 2333 96 //ppv confidence interval
cii proportions 7667 7663 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "20 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Children" && Biomarker == "IgA/IgG-DGP"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 20 U/mL threshold" 8 "Study estimate, 20 U/mL threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9640 0.7740, m(diamond) mc(black) msiz(small) || ///
	pci 0.9640 0.4404 0.9640 0.9371, lc(black) || ///
	pci 0.9172 0.7740 0.9848 0.7740, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* IgA/IgG tTG/DGP
use ma_data, clear
* Meta-analysis, most commonly reported threshold
metandi2 TP FP FN TN if Adult_child_res == "Children" && Biomarker == "IgA/IgG-tTG/DGP" && Index_threshold == "20 U/mL", u
display %4.0f 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) // tp
display %4.0f 100 - ( 100 * ( exp( e(b)[1,1] ) / ( 1 + exp( e(b)[1,1] ) ) ) ) // fn
display %4.0f 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) // tn
display %4.0f 9900 - ( 9900 * ( exp( e(b)[1,2] ) / ( 1 + exp( e(b)[1,2] ) ) ) ) // fp
cii proportions 3842 96 // ppv confidence interval
cii proportions 6158 6154 // npv confidence interval
* Summary ROC plot
gen common_thresh = (Index_threshold == "20 U/mL") // create variable indicating most commonly reported threshold
keep if Adult_child_res == "Children" && Biomarker == "IgA/IgG-tTG/DGP"
total total if common_thresh == 1 // total number of patients
total cd if common_thresh == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode common_thresh (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Summary point, 20 U/mL threshold" 8 "Study estimate, 20 U/mL threshold" 9 "Study estimate, other threshold" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if common_thresh == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if common_thresh == 1, m(smcircle) mfc(pink%20) mlc(pink%70) msiz(vsmall) || ///
	scatteri 0.9564 0.6216, m(diamond) mc(black) msiz(small) || ///
	pci 0.9564 0.5282 0.9564 0.7068, lc(black) || ///
	pci 0.8387 0.6216 0.9893 0.6216, lc(black) || ///
	scatteri . ., msiz(medium) mfc(pink%20) mlc(pink%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))