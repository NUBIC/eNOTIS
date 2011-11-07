def physical_measures_weight_waist_circumference_blood_pressure
  section "Weight, WC, and Blood Pressure" do
    q_weight "Weight (pounds):"
    a :string
    
    q_waist "Waist Circumference",
    :help_text => "(cm)"
    a :string
    
    q_blood_pressure "Blood Pressure",
    :help_text => "systolic/diastolic (mmHg)"
    a :string
  end
end