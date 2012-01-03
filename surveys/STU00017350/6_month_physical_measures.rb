survey "6 month - Physical Measures" ,:irb_number=>'STU00017350' do
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
