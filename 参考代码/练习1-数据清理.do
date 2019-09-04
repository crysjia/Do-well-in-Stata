use "pm25_beijing.dta" , clear

* 这里用 replace 的方法
format %50s v
drop in 1/315
drop in 179/201
gen i = floor((_n-1)/15)  
bys i : gen j = _n
reshape wide v , i(i) j(j)
compress

foreach var of varlist _all {
	cap replace `var' = subinstr(`var',`"<td class="O3_8h_dn">"',"",1)  // 注意双引号的用法 help quotes
	cap replace `var' = subinstr(`var',"<td>","",1) 
	cap replace `var' = subinstr(`var',"</td>","",1)
	destring `var' , replace
}

* 这里用正则表达式的方法
format %50s v
drop in 1/315
drop in 179/201
gen i = floor((_n-1)/15) 
bys i : gen j = _n

replace v = ustrregexra(v,`"<td>|</td>|<tr>|</tr>|<td class="O3_8h_dn">"',"")
reshape wide v , i(i) j(j)
compress
