********************************************************************************
*								Number of reviews							   *
********************************************************************************
preserve
keep if sample == 1
#delimit ;
quietly reg log_number_of_reviews i.race_sex_res i.age,  
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model1

#delimit ; 
quietly reg log_number_of_reviews i.race_sex_res i.age $loc_controls,
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model2

// Add listing specification
#delimit ;
quietly reg log_number_of_reviews i.race_sex_res i.age 
			$prop_controls,
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model3
				
// Add host specification
#delimit ;
quietly reg log_number_of_reviews i.race_sex_res i.age 
			$full_controls,
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model4

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

estadd local controlgroup1 "Yes" : model2 model3 model4
estadd local controlgroup2 "Yes" : model3 model4
estadd local controlgroup3 "Yes" : model4

#delimit ;
esttab model1 model2 model3 model4 using
	"$repository/code/tables/tex_output/individual_tables/number_reviews.tex", 
		se ar2 replace label 
		keep(_cons *.race_sex_res) drop(1.race_sex_res)
		mtitles("Model 1" "Model 2" "Model 3" "Model 4")
		stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
		labels("Location Controls" "Property Controls" 
				"Host Controls" "\hline \vspace{-1.25em}" 
				"Observations" "Adjusted R2"))  
		fragment
;
#delimit cr
restore
