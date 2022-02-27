***************************************************************
*** CEMENT_ReplicationAERPP.do
*** Donna Ginther
*** August 22, 2020
*** This program produces the tables in the Corrigendum to 
*** Ginther, Donna K., Currie, Janet M., Blau, Francine D., Croson, Rachel T.A. 
*** (2020). “Can Mentoring Help Female Assistant Professors in Economics? An Evaluation by     *** Randomized Trial.”  American Economic Review Papers and Proceedings. 110: 205-209.
*** It also updates the tables in NBER Working Paper # 26864
***
*** The new dataset corrects for incorrect ID information used in Table 4 columns 1-5;
*** It also removes three duplicate observations from the data
***************************************************************

#delimit ;
clear all;
set mem 800m; 
set more off;
capture log close;

log using Cement_ReplicationAERPP.out, text replace;

* Remove the comment below if you do not have outreg2 installed;
* ssc install outreg2;


use  "cement_update2020.dta";

* Table 1;
	

gen retreat = treat - firsttime;

* Table 1 Columns 4 and 3;
	
tab cohortc firsttime;

* Table 1 Column 5 retreated;
tab cohortc retreat;

* Table 1 Column 5, reapplied;
tab cohortc reapplied;


* Table 2 estimates;

sum tenure2 tenurejobtop100 nonacadlastjob tenstream tenstreamtop tenurejobtop30 tenurejobtop50 tenurejobtop200 
tenurejobtop201 firstjobtop10 firstjobtop20 firstjobtop40 firstjobtop41_100 firstjobtop201;


local varlist "top10phd top20phd top40phd phd_forn acadfirstjob 
firstjobtop10 firstjobtop20 firstjobtop40 firstjobtop41_100 firstjobtop201 phdyr";

	
    foreach var in  `varlist' {;
		
			     ttest `var' if tensamp==1, by(treat);
				 };
			
				 
				* #7
*  a fancier way to create a matrix;

local nvars : word count `varlist';
matrix stats = J(`nvars',4,-99);
matrix colnames stats = Treat Control t_test t_prob;
matrix rownames stats = `varlist';
* matrix list stats;


*  #5
*  collect t-test results in matrix;

local irow = 0;
foreach var of varlist `varlist' {;
    local ++irow;
    qui ttest `var' if tensamp==1, by(treat);
    matrix stats[`irow',1] = r(mu_2);
    matrix stats[`irow',2] = r(mu_1); 
    matrix stats[`irow',3] = r(t);    
    matrix stats[`irow',4] = r(p);    
};



* creating a header
local n_treat = r(N_1);
local n_control = r(N_2);
local header "Table 2 Balance Tests";



*** Table 2;

matrix list stats, format(%9.3f) title(`header'); 

* First stage estimates;

reg treat firsttimec i.cohortc yrsphd8-yrsphd16;

* Table 3 Regression Results;

foreach var of varlist tenstream tenstreamtop tenure2 tenurejobtop30 tenurejobtop50 tenurejobtop100
tenurejobtop200 tenurejobtop201 nonacadlastjob {;
			
local replace = cond("`var'"=="tenstream", "replace","","");

quietly summ `var'; 

local depmean = r(mean);

ivregress 2sls `var'  i.cohortc yrsphd8-yrsphd16 (treat=firsttimec);

outreg2 using Table3.xls, bd(3) td(3) alpha(.01, .05, .10) ct(`var') bracket label `replace' addstat (Mean, `depmean');	

};

* Table 4 Regression Results;

local varlist "pretengrant_total pretenpub_total3 pretenpubR1 pretenpubR2 pretenpubR3";

foreach var of varlist pretengrant_total pretenpub_total3 pretenpubR1 pretenpubR2 pretenpubR3 {;

local replace = cond("`var'"=="pretengrant_total", "replace","","");

quietly summ `var'; 

local depmean = r(mean);

ivregress 2sls `var'  i.cohortc yrsphd8-yrsphd16 (treat=firsttimec);
outreg2 using Table4.xls, bd(3) td(3) alpha(.01, .05, .10) bracket ct(`var') label `replace' addstat (Mean, `depmean');

};

foreach var of varlist tenurejobtop30 tenurejobtop50 {;

quietly summ `var'; 

local depmean = r(mean);

ivregress 2sls `var' i.cohortc yrsphd8-yrsphd16 pretenpubR1 pretenpubR2 pretenpubR3 pretengrant_total (treat=firsttimec);
outreg2 using Table4.xls, bd(3) td(3) alpha(.01, .05, .10) bracket ct(`var') append addstat (Mean, `depmean');
};


*  NBER Appendix Tables;

keep if cohortc<6;


* First stage estimates;

reg treat firsttimec i.cohortc yrsphd8-yrsphd16;

* Table A1 Regression Results;

foreach var of varlist tenstream tenstreamtop tenure2 tenurejobtop30 tenurejobtop50 tenurejobtop100
tenurejobtop200 tenurejobtop201 nonacadlastjob {;
			
local replace = cond("`var'"=="tenstream", "replace","","");

quietly summ `var'; 

local depmean = r(mean);

ivregress 2sls `var'  i.cohortc yrsphd8-yrsphd16 (treat=firsttimec);

outreg2 using TableA1.xls, bd(3) td(3) alpha(.01, .05, .10) bracket ct(`var') label `replace' addstat (Mean, `depmean');	

};

* Table A2 Regression Results;

local varlist "pretengrant_total pretenpub_total3 pretenpubR1 pretenpubR2 pretenpubR3";

foreach var of varlist pretengrant_total pretenpub_total3 pretenpubR1 pretenpubR2 pretenpubR3 {;

local replace = cond("`var'"=="pretengrant_total", "replace","","");

quietly summ `var'; 

local depmean = r(mean);

ivregress 2sls `var'  i.cohortc yrsphd8-yrsphd16 (treat=firsttimec);
outreg2 using TableA2.xls, bd(3) td(3) alpha(.01, .05, .10) bracket ct(`var') label `replace' addstat (Mean, `depmean');

};

foreach var of varlist tenurejobtop30 tenurejobtop50 {;

quietly summ `var'; 

local depmean = r(mean);

ivregress 2sls `var' i.cohortc yrsphd8-yrsphd16 pretenpubR1 pretenpubR2 pretenpubR3 pretengrant_total (treat=firsttimec);
outreg2 using TableA2.xls, bd(3) td(3) alpha(.01, .05, .10) bracket ct(`var') append addstat (Mean, `depmean');
};


