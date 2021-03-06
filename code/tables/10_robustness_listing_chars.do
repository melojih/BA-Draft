********************************************************************************
*		  Property Characteristics Robustness 		    					   *
********************************************************************************
preserve
keep if sample == 1
** State robustness checks do-file
set more off
set emptycells drop 

** Predicted price in LA
#delimit ; 
quietly reg log_price $prop_controls
			summary_polarity summary_subjectivity 
			miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost 
				if state == "CA",
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
predict predict_price_LA
sum predict_price_LA
local mean_price_LA = `r(mean)'

** Predicted price in NYC
#delimit ; 
quietly reg log_price $prop_controls
			summary_polarity summary_subjectivity 
			miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost 
				if state == "NY",   //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
predict predict_price_NY
sum predict_price_NY
local mean_price_NY = `r(mean)'

** Predicted price in Chicago
#delimit ; 
quietly reg log_price $full_controls
				if state == "IL",   //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
predict predict_price_chi
sum predict_price_chi
local mean_price_chi = `r(mean)'

****** Low/high price robustness 
#delimit ; 
quietly reg log_price i.race_res $prop_controls 
			summary_polarity summary_subjectivity 
			miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost 
				if predict_price_LA < `mean_price_LA' & state=="CA",
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model1

#delimit ;
quietly reg log_price i.race_res $prop_controls 
			summary_polarity summary_subjectivity 
			miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost 
				if predict_price_LA > `mean_price_LA' & state=="CA",
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model2 

#delimit ;
quietly reg log_price i.race_res $prop_controls 
			summary_polarity summary_subjectivity 
			miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost 
				if predict_price_NY < `mean_price_NY' & state=="NY",
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model3 

#delimit ; 
quietly reg log_price i.race_res $prop_controls 
			summary_polarity summary_subjectivity 
			miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost 
				if predict_price_NY > `mean_price_NY' & state=="NY",
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model4

#delimit ; 		
quietly reg log_price i.race_res $full_controls
				if predict_price_chi < `mean_price_chi' & state=="IL",
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model5 

#delimit ; 
 quietly reg log_price i.race_res $full_controls 
				if predict_price_chi > `mean_price_chi' & state=="IL",
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model6

#delimit ; 
quietly reg log_price i.race_res $full_controls
				if first_review_year < 15,
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model7 

#delimit ; 
quietly reg log_price i.race_res $full_controls
				if first_review_year < 99 & first_review_year > 14,
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model8 

#delimit ; 			
quietly reg log_price i.race_res $full_controls
				if property_type == "Apartment" | property_type == "Loft",
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model9 

#delimit ; 
quietly reg log_price i.race_res $full_controls
				if property_type == "Townhouse" | property_type == "Condominium",
				vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model10 

#delimit ; 			
quietly reg log_price i.race_res $full_controls
				if property_type == "House" | property_type == "Guesthouse",
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr

eststo model11 


local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : model1 model2 model3 model4 model7 model8 model9 model10 model11
estadd local controlgroup2 "Yes" : model1 model2 model3 model4 model7 model8 model9 model10 model11
estadd local controlgroup3 "Yes" : model1 model2 model3 model4 model7 model8 model9 model10 model11


// Esttab the table 
#delimit ;
esttab model1 model2 model3 model4 model7 model8 model9 model10 model11 
		using "$repository/code/tables/tex_output/individual_tables/robustness_listing_char.tex", 
	se ar2 replace label 
	keep(*.race_res) drop(1.race_res)
	mtitles("Low \\$ LA" 
			"High \\$ LA" "Low \\$ NY" "High \\$ NY" "Older Listings" 
			"Newer Listings" "Apartments" "Condos" "Houses") //Did not inlude m5 and m6
	stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
	labels("Location Controls" "Property Controls" 
		   "Host Controls" "\hline \vspace{-1.25em}"
		   "Observations" "Adjusted R2"))
	fragment 
;
#delimit cr
restore
