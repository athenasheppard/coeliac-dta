************************************************************************
** Name: coeliac_directcompar.do                                      **
** Purpose: Meta-analyse comparative accuracy data (Table 4)          **
** Creator: Athena L Sheppard                                         **
** Contact: als75@leicester.ac.uk                                     **
** Stata version 16.0 (Created 17 May 2021)                           **
************************************************************************


* Set working directory
cd "D:\Coeliac DTA review\Stata\Data"


* Import meta-analysis data
use ma_data, clear


* Iga tTG vs. IgA EMA
* Create variable indicating whether a study directly compared IgA tTG and IgA EMA
gen ttg = (Biomarker == "IgA-tTG")
gen ema = (Biomarker == "IgA-EMA")
bysort RefID Adult_child_res: egen compar=total(ttg+ema)
keep if compar == 2 & (Biomarker == "IgA-tTG" | Biomarker == "IgA-EMA")

* Calculate marginal sensitivities
gen ema_sens = .
replace ema_sens = sens if Biomarker == "IgA-EMA"
bysort RefID: replace ema_sens = ema_sens[_n-1] if ema_sens==.
gen ttg_sens = .
replace ttg_sens = sens if Biomarker == "IgA-tTG"
bysort RefID: replace ttg_sens = ttg_sens[_n+1] if ttg_sens==.

* Calculate marginal specificities
gen ema_spec = .
replace ema_spec = spec if Biomarker == "IgA-EMA"
bysort RefID: replace ema_spec = ema_spec[_n-1] if ema_spec==.
gen ttg_spec = .
replace ttg_spec = spec if Biomarker == "IgA-tTG"
bysort RefID: replace ttg_spec = ttg_spec[_n+1] if ttg_spec==.

* Calculate relative sensitivity and specificity
gen rsens = ema_sens / ttg_sens
gen rspec = ema_spec / ttg_spec

* Summarise comparative test accuracy
* Adults
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-EMA"
summarize rsens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize rspec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"

* Children
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
tab Index_threshold if Adult_child_res == "Children" && Biomarker == "IgA-EMA"
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
summarize sens if Adult_child_res == "Children" && Biomarker == "IgA-EMA"
summarize spec if Adult_child_res == "Children" && Biomarker == "IgA-EMA"
summarize rsens if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
summarize rspec if Adult_child_res == "Children" && Biomarker == "IgA-tTG"

* Total number of patients and number of patients with coeliac disease
bysort RefID Adult_child_res: egen n=max(total)
bysort RefID Adult_child_res: egen n_cd=max(cd)
total n if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total n_cd if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total n if Adult_child_res == "Children" && Biomarker == "IgA-tTG"
total n_cd if Adult_child_res == "Children" && Biomarker == "IgA-tTG"


* Iga tTG vs. IgA DGP
use ma_data, clear

* Create variable indicating whether a study directly compared IgA tTG and IgA DGP
gen ttg = (Biomarker == "IgA-tTG")
gen dgp = (Biomarker == "IgA-DGP")
bysort RefID Adult_child_res: egen compar=total(ttg+dgp)
keep if compar == 2 & (Biomarker == "IgA-tTG" | Biomarker == "IgA-DGP")

* Calculate marginal sensitivities
gen dgp_sens = .
replace dgp_sens = sens if Biomarker == "IgA-DGP"
bysort RefID: replace dgp_sens = dgp_sens[_n-1] if dgp_sens==.
gen ttg_sens = .
replace ttg_sens = sens if Biomarker == "IgA-tTG"
bysort RefID: replace ttg_sens = ttg_sens[_n+1] if ttg_sens==.

* Calculate marginal specificities
gen dgp_spec = .
replace dgp_spec = spec if Biomarker == "IgA-DGP"
bysort RefID: replace dgp_spec = dgp_spec[_n-1] if dgp_spec==.
gen ttg_spec = .
replace ttg_spec = spec if Biomarker == "IgA-tTG"
bysort RefID: replace ttg_spec = ttg_spec[_n+1] if ttg_spec==.

* Calculate relative sensitivity and specificity
gen rsens = dgp_sens / ttg_sens
gen rspec = dgp_spec / ttg_spec

* Summarise comparative test accuracy
* Adults
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-DGP"
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-DGP"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-DGP"
summarize rsens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize rspec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"

* Total number of patients and number of patients with coeliac disease
bysort RefID Adult_child_res: egen n=max(total)
bysort RefID Adult_child_res: egen n_cd=max(cd)
total n if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total n_cd if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"


* Iga tTG vs. IgG DGP
use ma_data, clear

* Create variable indicating whether a study directly compared IgA tTG and IgA DGP
gen ttg = (Biomarker == "IgA-tTG")
gen dgp = (Biomarker == "IgG-DGP")
bysort RefID Adult_child_res: egen compar=total(ttg+dgp)
keep if compar == 2 & (Biomarker == "IgA-tTG" | Biomarker == "IgG-DGP")

* Calculate marginal sensitivities
gen dgp_sens = .
replace dgp_sens = sens if Biomarker == "IgG-DGP"
bysort RefID: replace dgp_sens = dgp_sens[_n-1] if dgp_sens==.
gen ttg_sens = .
replace ttg_sens = sens if Biomarker == "IgA-tTG"
bysort RefID: replace ttg_sens = ttg_sens[_n+1] if ttg_sens==.

* Calculate marginal specificities
gen dgp_spec = .
replace dgp_spec = spec if Biomarker == "IgG-DGP"
bysort RefID: replace dgp_spec = dgp_spec[_n-1] if dgp_spec==.
gen ttg_spec = .
replace ttg_spec = spec if Biomarker == "IgA-tTG"
bysort RefID: replace ttg_spec = ttg_spec[_n+1] if ttg_spec==.

* Calculate relative sensitivity and specificity
gen rsens = dgp_sens / ttg_sens
gen rspec = dgp_spec / ttg_spec

* Summarise comparative test accuracy
* Adults
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgG-DGP"
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgG-DGP"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgG-DGP"
summarize rsens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize rspec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"

* Total number of patients and number of patients with coeliac disease
bysort RefID Adult_child_res: egen n=max(total)
bysort RefID Adult_child_res: egen n_cd=max(cd)
total n if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total n_cd if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"


* Iga tTG vs. IgG DGP
use ma_data, clear

* Create variable indicating whether a study directly compared IgA tTG and IgA DGP
gen ttg = (Biomarker == "IgA-tTG")
gen dgp = (Biomarker == "IgA/IgG-DGP")
bysort RefID Adult_child_res: egen compar=total(ttg+dgp)
keep if compar == 2 & (Biomarker == "IgA-tTG" | Biomarker == "IgA/IgG-DGP")

* Calculate marginal sensitivities
gen dgp_sens = .
replace dgp_sens = sens if Biomarker == "IgA/IgG-DGP"
bysort RefID: replace dgp_sens = dgp_sens[_n-1] if dgp_sens==.
gen ttg_sens = .
replace ttg_sens = sens if Biomarker == "IgA-tTG"
bysort RefID: replace ttg_sens = ttg_sens[_n+1] if ttg_sens==.

* Calculate marginal specificities
gen dgp_spec = .
replace dgp_spec = spec if Biomarker == "IgA/IgG-DGP"
bysort RefID: replace dgp_spec = dgp_spec[_n-1] if dgp_spec==.
gen ttg_spec = .
replace ttg_spec = spec if Biomarker == "IgA-tTG"
bysort RefID: replace ttg_spec = ttg_spec[_n+1] if ttg_spec==.

* Calculate relative sensitivity and specificity
gen rsens = dgp_sens / ttg_sens
gen rspec = dgp_spec / ttg_spec

* Summarise comparative test accuracy
* Adults
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
tab Index_threshold if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-DGP"
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize sens if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-DGP"
summarize spec if Adult_child_res == "Adults" && Biomarker == "IgA/IgG-DGP"
summarize rsens if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
summarize rspec if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"

* Total number of patients and number of patients with coeliac disease
bysort RefID Adult_child_res: egen n=max(total)
bysort RefID Adult_child_res: egen n_cd=max(cd)
total n if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"
total n_cd if Adult_child_res == "Adults" && Biomarker == "IgA-tTG"