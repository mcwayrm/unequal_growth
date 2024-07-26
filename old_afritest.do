log using h:\intldata\africaed\afritest, replace text
 
* This program program examines the Pole de Dakar data to see whether
* it is possible to construct comparable test score data for Africa,
* and if so how that data does in regression analysis

* First, check correlations in the data.

use h:\intldata\africaed\afritest.dta
su
* Correlations for pasec, mla and sacmeq are high, but not very significant
* given only 3 or 5 observations in common
pwcorr pasec5 mla1999 sacmeq, obs sig /* note no obs w/ pasec & sacmeq */

* The 2 litpr6yr variables are highly correlated as well
pwcorr lit*, obs sig

* The 2 litpr6yr vars. are highly correlated w/ pasec & mla, less w/ sacmeq
* The adjusted litpr6yr variable is more highly correlated with all three
pwcorr lit* pasec5 mla1999 sacmeq, obs sig

* Second, regress mla on both pasec and sacmeq to get predicted mla.

reg mla1999 pasec
predict mla_pas
reg mla1999 sacmeq 
predict mla_sac

gen mla99hat=mla1999
replace mla99hat=mla_pas if mla99hat==.
replace mla99hat=mla_sac if mla99hat==.
drop mla_pas mla_sac
su
pwcorr mla99hat lit*, obs sig /* 18 common obs.  correlation is good */

* Third, see what what happens with adding these to Africa only regressions.

sort country
merge country using h:\intldata\africaed\MRWwGINI.dta
tab _m
l country if _m==1 /* These 4 are not in the Mankiw, Romer & Weil data */
drop if _m~=3
drop if country=="Morocco" /* Not Subsaharan Africa */

reg lggl1985 lgngdelta lgIY lgSCHOOL if nsample==1 /* looks good */
reg lggl1985 lgngdelta lgIY lgSCHOOL  /* also looks good */
reg lggl1985 lgngdelta lgIY lgSCHOOL if mla99hat~=. /* just as good */
reg lggl1985 lgngdelta lgIY lgSCHOOL mla99hat  /* add tests, no big effect */
reg lggl1985 lgngdelta lgIY lgSCHOOL if litpr6yadj~=. /* sch a little weaker */
reg lggl1985 lgngdelta lgIY lgSCHOOL litpr6yadj /* add lit, sign but no effect */

* Try again using test scores, with dummies for missing test score variables

gen sometest=(pasec5~=. | mla1999~=. | sacmeq~=.)
su pasec5 mla1999 sacmeq
gen mla1999x=mla1999
replace mla1999x=0 if mla1999x==.
gen nomla1999=mla1999==.
gen pasec5x=pasec5 if mla1999==.
replace pasec5x=0 if pasec5x==.
gen nopasec5=(pasec5==. | mla1999~=.)
gen sacmeqx=sacmeq if mla1999==.
replace sacmeqx=0 if sacmeqx==.
gen nosacmeq=(sacmeq==. | mla1999~=.)

reg lggl1985 lgngdelta lgIY lgSCHOOL
* According to Pole de Dakar report, Togo, Mali and Niger have possible
* bad pasec data, but we can use mla1999 for Mali and Niger.
reg lggl1985 lgngdelta lgIY lgSCHOOL if sometest==1 & country~="Togo"
reg lggl1985 lgngdelta lgIY lgSCHOOL pasec5x mla1999x sacmeqx no* if sometest==1 /*
 */ & country~="Togo"

* Since sacmeqx has wrong sign, repeat only for countries with pasec5 or mla1999
reg lggl1985 lgngdelta lgIY lgSCHOOL if (pasec5~=. | mla1999~=.) & country~="Togo"
reg lggl1985 lgngdelta lgIY lgSCHOOL pasec5x mla1999x sacmeqx no* /*
 */ if (pasec5~=. | mla1999~=.) & country~="Togo"

* Check for differences in former English and former French colonies

gen English=(country=="Botswana" | country=="Gambia, The" | country=="Ghana" /*
 */ | country=="Guinea" | country=="Kenya" | country=="Lesotho" | country=="Malawi" /*
 */ | country=="Mauritius" | country=="Namibie" | country=="Nigeria" /*
 */ | country=="S. Africa" | country=="Seychelles" | country=="Sierra Leone" /*
 */ | country=="Swaziland" | country=="Tanzania" | country=="Uganda" /*
 */ | country=="Zambia" | country=="Zimbabwe")

gen French=(country=="Benin" | country=="Burkina Faso" | country=="Cameroon" /*
 */ | country=="Central Afr. Rep." | country=="Chad" | country=="Congo, People. Rep" /*
 */ | country=="Ivory Coast" | country=="Madagascar" | country=="Mali" /*
 */ | country=="Mauritania" | country=="Niger" | country=="Senegal" /*
 */ | country=="Togo")

gen Belgian=(country=="Burundi" | country=="Rwanda") 

gen Portug=(country=="Angola" | country=="Guinee Bissau" | country=="Mozambique" /*
 */ | country=="Sao Tome & princ.")

* Interesting for former French colonies
reg lggl1985 lgngdelta lgIY lgSCHOOL if French==1
reg lggl1985 lgngdelta lgIY lgSCHOOL if French==1 & pasec5~=.
reg lggl1985 lgngdelta lgIY lgSCHOOL pasec5 if French==1

* Very low sample size for English colonies using the mla1999 test
reg lggl1985 lgngdelta lgIY lgSCHOOL if English==1 
reg lggl1985 lgngdelta lgIY lgSCHOOL if English==1 & mla1999~=.
reg lggl1985 lgngdelta lgIY lgSCHOOL mla1999 if English==1 

* Not very decisive using the sacmeq test
reg lggl1985 lgngdelta lgIY lgSCHOOL if English==1 
reg lggl1985 lgngdelta lgIY lgSCHOOL if English==1 & sacmeq~=.
reg lggl1985 lgngdelta lgIY lgSCHOOL sacmeq if English==1 

/*

*reg lggl1985 lgngdelta lgIY lgSCHOOL if litpr6yadj~=. & mla99hat~=. /* good */
*ivreg lggl1985 lgngdelta lgIY lgSCHOOL (mla99hat = litpr6yadj) /* nothing */

* Fourth, add some interaction terms, does not seem to work at all
gen schxtest=lgSCHOOL*mla99hat
gen scxlitpr=lgSCHOOL*litpr6yadj
reg lggl1985 lgngdelta lgIY lgSCHOOL mla99hat schxtest
test mla99hat schxtest /* not at all significant */
reg lggl1985 lgngdelta lgIY lgSCHOOL litpr6yadj scxlitpr

* Fifth, to expand sample add predicted mla based on litpr6yadj

reg mla1999 litpr6yadj 
predict mla_lit
replace mla99hat=mla_lit if mla99hat==.
drop mla_lit
reg lggl1985 lgngdelta lgIY lgSCHOOL if mla99hat~=. /* just as good */
reg lggl1985 lgngdelta lgIY lgSCHOOL mla99hat  /* test sign, no effect on educ. */

*/

* Finally, try replicating H & W for Africa only using PASEC data

* First, get GDP and schooling data from Cohen and Soto data

clear

use h:\intldata\AfricaEd\cohensot.dta
gen Africa=1 if (country=="Angola" | country=="Benin" | country=="Burkina Faso" /* 
 */ | country=="Burundi" | country=="Cameroon" | country=="Central African republic" /*
 */ | country=="Cote dIvoire" | country=="Ethiopia"| country=="Gabon" | country=="Ghana" /*
 */ | country=="Kenya" | country=="Madagascar" | country=="Malawi" | country=="Mali" /*
 */ | country=="Mauritius" | country=="Mozambique" | country=="Niger" /*
 */ | country=="Nigeria" | country=="Senegal" | country=="Sierra Leone" /*
 */ | country=="South Africa" | country=="Sudan" | country=="Tanzania" /*
 */ | country=="Uganda" | country=="Zambia" | country=="Zimbabwe")

keep if Africa==1
drop high oecd_high bl25 dd Africa

reshape wide ty25 y k, i(country) j(year)

su /* 1960 data missing a lot, so just do 1970 to 1990 */

gen gdpgrth=(y1990-y1970)/20  /* Note that y's are already in logs */
keep country gdpgrth y1970 ty251970
sort country
save h:\intldata\AfricaEd\temp.dta, replace

use h:\intldata\AfricaEd\afritest.dta
replace country="Central African republic" if country=="Central Afr. Rep."
replace country="Cote dIvoire" if country=="Ivory Coast"
replace country="South Africa" if country=="S. Africa" 
sort country
merge country using h:\intldata\AfricaEd\temp.dta
tab _m
l country if _m==2
l country if _m==1
drop if _m~=3
drop _m

* Allow for same flexibility in the different tests
gen sometest=(pasec5~=. | mla1999~=. | sacmeq~=.)
su pasec5 mla1999 sacmeq

gen mla1999x=mla1999
gen k_mla1999=mla1999x~=.
replace mla1999x=0 if mla1999x==.

gen pasec5x=pasec5 if mla1999==.
gen k_pasec5=pasec5x~=.
replace pasec5x=0 if pasec5x==.

gen sacmeqx=sacmeq if mla1999==.
gen k_sacmeq=sacmeqx~=.
replace sacmeqx=0 if sacmeqx==.

l country mla1999x k_mla1999 pasec5x k_pasec5 sacmeqx k_sacmeq if sometest==1

* These regressions show that this is pretty hopeless
regress gdpgrth y1970 ty251970 
regress gdpgrth y1970 ty251970 if sometest==1
regress gdpgrth y1970 ty251970 mla1999x k_mla1999 pasec5x k_pasec5 sacmeqx k_sacmeq

log close

