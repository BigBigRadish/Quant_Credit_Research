set more off
clear 

use "C:\Users\Haritz\Desktop\Haritz Git\Rust problem set\Rust.dta"

logit a x 
gen x2 = x^2
gen x3 = x^3

logit a x x2 x3, nocons nolog
predict fitted
gen fittedzero = 1 - fitted
gen HM         = log(1 - fitted) - log(fitted)
gen beta       = 0.95

gen phat11     = 0.06502
gen phat12     = 0.02915
gen phat13     = 0.04353
gen phat14     = 0.12051
gen phat15     = 0.31663
gen phat16     = 0.49881
gen phat17     = 0.43439

gen vx1        = 1/(1 - beta) - (beta/(1 - ///
beta))*log(phat11)
gen v10        = vx1 + log(1 - phat11) - log(phat11)
gen v20        = vx1 + log(1 - phat12) - log(phat12)
gen v30        = vx1 + log(1 - phat13) - log(phat13)
gen v40        = vx1 + log(1 - phat14) - log(phat14)
gen v50        = vx1 + log(1 - phat15) - log(phat15)
gen v60        = vx1 + log(1 - phat16) - log(phat16)
gen v70        = vx1 + log(1 - phat17) - log(phat17)

gen u10        = v10 - beta*log(exp(vx1) + exp(v20))
gen u20        = v20 - beta*log(exp(vx1) + exp(v30))
gen u30        = v30 - beta*log(exp(vx1) + exp(v40))
gen u40        = v40 - beta*log(exp(vx1) + exp(v50))
gen u50        = v50 - beta*log(exp(vx1) + exp(v60))
gen u60        = v60 - beta*log(exp(vx1) + exp(v70))
gen u70        = v70 - beta*log(exp(vx1) + exp(v70))

gen utilities = 0
replace utilities = u10 if x==1
replace utilities = u20 if x==2
replace utilities = u30 if x==3
replace utilities = u40 if x==4
replace utilities = u50 if x==5
replace utilities = u60 if x==6
replace utilities = u70 if x==7
replace utilities = 1   if a==1

reg utilities x rc, nocons

* Now I will use the method outlined by Paul Scott. The 
* results should be the same

gen pxtmr = 0
replace pxtmr = phat17 if x==6 | x==7
replace pxtmr = phat16 if x==5
replace pxtmr = phat15 if x==4
replace pxtmr = phat14 if x==3
replace pxtmr = phat13 if x==2
replace pxtmr = phat12 if x==1

gen LHS = log(fitted/fittedzero) + beta*log(phat11/pxtmr) 

reg LHS rc x, nocons
