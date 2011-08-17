def physical_measures_waist_circumference_blood_pressure
  section "WC" do
    q_waist "Waist Circumference",
    :help_text => "(cm)"
    a :string
    
    q_blood_pressure "Blood Pressure",
    :help_text => "systolic/diastolic (mmHg)"
    a :string
  end
end