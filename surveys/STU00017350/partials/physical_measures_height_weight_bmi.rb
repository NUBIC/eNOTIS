def physical_measures_height_weight_bmi
  section "WBMI" do
    q_height "Height",
    :help_text => "(inches)"
    a :string
    
    q_weight "Weight",
    :help_text => "(lbs)"
    a :string
    
    q_bmi "BMI",
    :help_text => "BMI = lbs*703/inches*inches"
    a :string
  end
end 