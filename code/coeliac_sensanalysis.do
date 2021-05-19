************************************************************************
** Name: coeliac_sensanalysis.do                                      **
** Purpose: Perform sensitivity analyses (Table 3, Appendix 5)        **
** Creator: Athena L Sheppard                                         **
** Contact: als75@leicester.ac.uk                                     **
** Stata version 16.0 (Created 17 May 2021)                           **
************************************************************************


* Set working directory
cd "D:\Coeliac DTA review\Stata\Data"


* Import meta-analysis data
use ma_data, clear


* Symptomatic patients only
* Adults
* IgA tTG
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic"
summarize ppv if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic"
summarize npv if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic"
* Summary ROC plot
gen symptoms = (Symptomatic == "Symptomatic") // create variable indicating reason for biopsy
keep if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total total if symptoms == 1 // total number of patients
total cd if symptoms == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode symptoms (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Symptomatic patients only" 6 "Symptomatic/risk group patients" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if symptoms == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if symptoms == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Adults
* IgA EMA
use ma_data, clear
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic"
summarize ppv if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic"
summarize npv if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic"
* Summary ROC plot
gen symptoms = (Symptomatic == "Symptomatic") // create variable indicating reason for biopsy
keep if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"
total total if symptoms == 1 // total number of patients
total cd if symptoms == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode symptoms (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Symptomatic patients only" 6 "Symptomatic/risk group patients" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if symptoms == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if symptoms == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Children
* IgA tTG
use ma_data, clear
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic"
summarize ppv if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic"
summarize npv if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& Symptomatic == "Symptomatic"
* Summary ROC plot
gen symptoms = (Symptomatic == "Symptomatic") // create variable indicating reason for biopsy
keep if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
total total if symptoms == 1 // total number of patients
total cd if symptoms == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode symptoms (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Symptomatic patients only" 6 "Symptomatic/risk group patients" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if symptoms == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if symptoms == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Children
* IgA EMA
use ma_data, clear
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic"
summarize ppv if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic"
summarize npv if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& Symptomatic == "Symptomatic"
* Summary ROC plot
gen symptoms = (Symptomatic == "Symptomatic") // create variable indicating reason for biopsy
keep if Adult_child_res == "Children" && Biomarker == "IgA-EMA"
total total if symptoms == 1 // total number of patients
total cd if symptoms == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode symptoms (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Symptomatic patients only" 6 "Symptomatic/risk group patients" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if symptoms == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if symptoms == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Biopsied all patients
* Adults
* IgA tTG
use ma_data, clear
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes"
summarize ppv if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes"
summarize npv if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes"
* Summary ROC plot
gen biopsy = (QUADAS_flow_ref == "Yes") // create variable indicating whether all patients underwent biopsy
keep if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total total if biopsy == 1 // total number of patients
total cd if biopsy == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode biopsy (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Biopsied all patients" 6 "Did not biopsy all patients" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if biopsy == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if biopsy == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Adults
* IgA EMA
use ma_data, clear
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes"
summarize ppv if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes"
summarize npv if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes"
* Summary ROC plot
gen biopsy = (QUADAS_flow_ref == "Yes") // create variable indicating whether all patients underwent biopsy
keep if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"
total total if biopsy == 1 // total number of patients
total cd if biopsy == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode biopsy (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Biopsied all patients" 6 "Did not biopsy all patients" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if biopsy == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if biopsy == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Children
* IgA tTG
use ma_data, clear
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes"
summarize ppv if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes"
summarize npv if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& QUADAS_flow_ref == "Yes"
* Summary ROC plot
gen biopsy = (QUADAS_flow_ref == "Yes") // create variable indicating whether all patients underwent biopsy
keep if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
total total if biopsy == 1 // total number of patients
total cd if biopsy == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode biopsy (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Biopsied all patients" 6 "Did not biopsy all patients" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if biopsy == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if biopsy == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Children
* IgA EMA
use ma_data, clear
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes"
summarize ppv if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes"
summarize npv if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& QUADAS_flow_ref == "Yes"
* Summary ROC plot
gen biopsy = (QUADAS_flow_ref == "Yes") // create variable indicating whether all patients underwent biopsy
keep if Adult_child_res == "Children" && Biomarker == "IgA-EMA"
total total if biopsy == 1 // total number of patients
total cd if biopsy == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode biopsy (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Biopsied all patients" 6 "Did not biopsy all patients" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if biopsy == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if biopsy == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Low risk of bias
* Adults
* IgA tTG
use ma_data, clear
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& ROB == "Low", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& ROB == "Low"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& ROB == "Low"
summarize ppv if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& ROB == "Low"
summarize npv if Adult_child_res == "Adults" && Biomarker == "IgA-tTG" ///
&& ROB == "Low"
* Summary ROC plot
gen lowrob = (ROB == "Low") // create variable indicating sets of 2x2 data at low risk of bias
keep if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total total if lowrob == 1 // total number of patients
total cd if lowrob == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode lowrob (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Low risk of bias" 6 "High or unclear risk of bias" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if lowrob == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if lowrob == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Adults
* IgA EMA
use ma_data, clear
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& ROB == "Low", missing
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& ROB == "Low"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& ROB == "Low"
summarize ppv if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& ROB == "Low"
summarize npv if Adult_child_res == "Adults" && Biomarker == "IgA-EMA" ///
&& ROB == "Low"
* Summary ROC plot
gen lowrob = (ROB == "Low") // create variable indicating sets of 2x2 data at low risk of bias
keep if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"
total total if lowrob == 1 // total number of patients
total cd if lowrob == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode lowrob (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Low risk of bias" 6 "High or unclear risk of bias" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if lowrob == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if lowrob == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Children
* IgA tTG
use ma_data, clear
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& ROB == "Low", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& ROB == "Low"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& ROB == "Low"
summarize ppv if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& ROB == "Low"
summarize npv if Adult_child_res == "Children" && Biomarker == "IgA-tTG" ///
&& ROB == "Low"
* Summary ROC plot
gen lowrob = (ROB == "Low") // create variable indicating sets of 2x2 data at low risk of bias
keep if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
total total if lowrob == 1 // total number of patients
total cd if lowrob == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode lowrob (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Low risk of bias" 6 "High or unclear risk of bias" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if lowrob == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if lowrob == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))


* Children
* IgA EMA
use ma_data, clear
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& ROB == "Low", missing
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& ROB == "Low"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& ROB == "Low"
summarize ppv if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& ROB == "Low"
summarize npv if Adult_child_res == "Children" && Biomarker == "IgA-EMA" ///
&& ROB == "Low"
* Summary ROC plot
gen lowrob = (ROB == "Low") // create variable indicating sets of 2x2 data at low risk of bias
keep if Adult_child_res == "Children" && Biomarker == "IgA-EMA"
total total if lowrob == 1 // total number of patients
total cd if lowrob == 1 // number of patients with coeliac disease
egen n = total(total) // calculate weighting based on number of patients
gen weight = total / n
expand 2 // duplicate data to ensure weights are distributed across both groups
replace spec = . if _n>(_N/2)
recode lowrob (0=1) (1=0) if spec==.
metandi TP FP FN TN if spec != . // meta-analysis across all thresholds
metandiplot TP FP FN TN if spec != ., ///
	summopts(off) curveopts(lc(lavender)) studyopts(m(none)) confopts(off) ///
	predopts(off) xtitle(, size(small)) ytitle(, size(small)) ///
	xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	graphregion(fc(white) lc(white)) legend(cols(1) symx(4pt) symy(2pt) ///
	size(vsmall) region(c(none)) ring(0) forces keygap(1.5) position(5) ///
	bmargin(vsmall) rowg(0.7pt) ///
	order(5 "Low risk of bias" 6 "High or unclear risk of bias" 2 "Summary ROC curve")) ///
	addplot(scatter sens spec [aw = weight] if lowrob == 0, m(smcircle) mfc(ebblue%20) mlc(ebblue%70) msiz(vsmall) || ///
	scatter sens spec [aw = weight] if lowrob == 1, m(smcircle) mfc(purple%20) mlc(purple%70) msiz(vsmall) || ///
	scatteri . ., msiz(medium) mfc(purple%20) mlc(purple%70) || ///
	scatteri . ., msiz(medium) mfc(ebblue%20) mlc(ebblue%70))
