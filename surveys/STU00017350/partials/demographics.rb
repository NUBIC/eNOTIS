def demographics
  section "D" do
    q_date_of_birth "Date of Birth:"
    a :date, :custom_class => "date"
    
    q_age "Age:"
    a :integer
    
    q_gender "Gender", :pick => :one
    a_female "Female"
    a_male "Male"
    
    q_marital_status "Marital Status", :pick => :one
    a_partner "Living with a partner to whom I'm not married"
    a_married "Married"
    a_single "Single"
    a_separated "Separated"
    a_divorsed "Divorced"
    a_widowed "Widowed"
    
    q_education "Highest Educational Level Completed", :pick => :one
    a_some_high_school "Some high school"
    a_high_school "High school degree/G.E.D/equivalent"
    a_trade_school "Trade school or specialty school"
    a_some_college "Some college"
    a_associate_degree "Associate's degree"
    a_bach_degree "Bachelor's degree"
    a_some_grad_school "Some graduate school"
    a_masters_degree "Master's degree"
    a_prof_degree "Professional degree"
    
    q_average_income "Average estimated household annual income", :pick => :one
    a_15 "$0 - $15,000"
    a_20 "$15,000 - $20,000"
    a_25 "$20,000 - $25,000"
    a_30 "$25,000 - $30,000"
    a_35 "$30,000 - $35,000"
    a_40 "$35,000 - $40,000"
    a_45 "$40,000 - $45,000"
    a_50 "$45,000 - $50,000"
    a_60 "$50,000 - $60,000"
    a_75 "$60,000 - $75,000"
    a_over75 "Over $75,000"
    
    q_race "Race", :pick => :one
    a_american_indian_alaska_native "American Indian/Alaska Native"
    a_asian "Asian"
    a_native_hawaiian "Native Hawaiian or Other Pacific Islander"
    a_black_or_african_american "Black of African American"
    a_white "White"
    a_more_than_one "More than one race"
    a_other "Other"
    
    q_ethnicity "Ethnicity:", :pick => :one
    a_hispanic "Hispanic or Latino"
    a_non_hispanic "Non-Hispanic or Latino"
  end
end