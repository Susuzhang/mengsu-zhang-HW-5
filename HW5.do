clear all
set more off, perm
set scrollbufsize 2000000


*Assignment 2******************************************************************************
*Exercise 2
set seed 100
set obs 10000
gen X1= runiform(1, 3)
gen X2= rgamma(3, 2)
gen X3= rbinomial(10000,0.3)
gen eps=rnormal(2,1)
gen Y=0.5+1.2*X1-0.9*X2+0.1*X3+eps
gen ydum=0
replace ydum=1 if Y> 299.4644
*Exercise 2
reg Y X1
*store the results and make a table.
est sto reg1
est tab reg1, se(3) title(reg1)

reg Y X1 X2 X3
est sto reg2
est tab reg2, se(3) title(reg2)
bootstrap, reps(49): regress Y X1 X2 X3
est sto bootstrapreg1
est tab bootstrapreg1, se(3) title(bootstrapreg1)
bootstrap, reps(499):regress Y X1 X2 X3
est sto bootstrapreg2
est tab bootstrapreg2, se(3) title(bootstrapreg2)
*Exercise4&5
probit ydum X1 X2 X3
margins, dydx(*) atmeans
margins, dydx(*) atmeans vce(delta)
probit ydum X1 X2 X3, vce(bootstrap, reps(499))

logit ydum X1 X2 X3
margins, dydx(*) atmeans
margins, dydx(*) atmeans vce(delta)

logit ydum X1 X2 X3, vce(bootstrap, reps(499))
bootstrap, reps(499):logit ydum X1 X2 X3
regress ydum X1 X2 X3, vce(robust)


*Assignment 3******************************************************************************
clear all
set more off, perm
set scrollbufsize 2000000
*Exercise 1
import excel "/Users/zhangmengsu/Desktop/product.xlsx", sheet("data1") firstrow clear
save "/Users/zhangmengsu/Desktop/product.dta",replace

import excel "/Users/zhangmengsu/Desktop/demos.xlsx", sheet("data2") firstrow clear
drop A
save "/Users/zhangmengsu/Desktop/demos.dta",replace
merge 1:m hhid using "/Users/zhangmengsu/Desktop/product.dta"
*average and dispersion in product characteristics
summarize PPk_Stk PBB_Stk PFl_Stk PHse_Stk PGen_Stk PImp_Stk PSS_Tub PPk_Tub PFl_Tub PHse_Tub
*market share
tabulate choice
tabulate Income choice

*Exercise 2&4
*Conditional logit
drop hhid

rename (PPk_Stk PBB_Stk PFl_Stk PHse_Stk PGen_Stk PImp_Stk PSS_Tub PPk_Tub PFl_Tub PHse_Tub)(c1 c2 c3 c4 c5 c6 c7 c8 c9 c10)

reshape long c, i(A) j(price)
gen dum=cond(price==choice,1,0)

asclogit dum c, case(A) alternatives(price)
est sto c_logit
estat mfx
 
*Exercise 3&4

asclogit dum, case(A) alternatives(price) casevar(Income)
est sto m_logit
estat mfx

*Exercise 5
asmixlogit dum ,random(c) casevars(Income) alternatives(price) case(A)
est sto all
drop if choice==1
drop if price==1
asmixlogit dum ,random(c) casevars(Income) alternatives(price) case(A)
est sto partial
hausman partial all, alleqs constant


*Assignment 4********************************************************************************
clear all
set more off, perm
set scrollbufsize 2000000
insheet using /Users/zhangmengsu/Desktop/econ613/Koop-Tobias.csv, names
*Exercise1
xtset personid timetrnd
bysort personid: gen t = _n
tabulate timetrnd logwage if personid == 2
tabulate timetrnd logwage if personid==4
tabulate timetrnd logwage if personid==6
tabulate timetrnd logwage if personid==8
tabulate timetrnd logwage if personid==12

*Exercise2 random effects
xtreg logwage educ potexper, re

*Exercise3 fixed effects
*between estimators
xtreg logwage educ potexper, be
*within estimators
xtreg logwage educ potexper, fe
*first time difference estimator
xtset personid t 
xtdes
gen logwage_D=D1.logwage
gen educ_D=D1.educ
gen potexper_D=D1.potexper
xtreg logwage_D educ_D potexper_D, fe

 
 
 
 
 
 
