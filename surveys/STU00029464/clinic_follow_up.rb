survey "Follow Up - Esophageal Center",:irb_number=>"STU00029464" do
  section "Smoking History" do
    q_ec_fu_smoke1  "Have you smoked at least 100 cigarettes (5 packs) in your entire life?", :pick => :one
      a_0 "No"
      a_1 "Yes"
      a_8 "Not answered"

    q_ec_fu_smoke2 "Do you currently smoke cigarettes?", :pick => :one
      a_0 "No"
      a_1 "Yes"
      a_8 "Not answered"
    
    q_ec_fu_smoke3 "On average, about how many cigarettes a day do you now smoke?", :pick => :one
      a_1 "Cigarettes per day", :string
      a_8 "Not answered"
    dependency :rule => "A"
    condition_A :q_ec_fu_smoke2, "==", :a_1
  end
  
  section "Alcohol Consumption" do
    q_ec_fu_alcohol1 "In any one year, have you had at least 12 drinks of any type of alcoholic beverage? A drink is a 12oz. beer, a 5oz. glass of wine, one and half ounces of liquor.", :pick => :one
      a_0 "No"
      a_1 "Yes"
      a_8 "Not answered" 

    q_ec_fu_alcohol2 "In the past 12 months, how often did you drink any type of alcoholic beverage?", :pick => :one
      a_1 "Every day"
      a_2 "Several times per week"
      a_3 "Several times per month"
      a_4 "Once a month or less"
      a_5 "Never"
      a_8 "Not answered"
    
    q_ec_fu_alcohol3 "In the past 12 months, on those days that you drank alcoholic beverages, on average, how many drinks did you have?", :pick => :one
      a_0 "0"
      a_1 "1-2"
      a_2 "3-4"
      a_3 "5-6"
      a_4 "7-8"
      a_5 "9-10"
      a_6 "More than 10"
      a_8 "Not answered"
  end
  section "Current Symptoms" do
    q_ec_fu_symptoms1 "What symptoms have you experienced in the past 7 days?", :pick => :any
      a_1 "abdominal pain"
      a_2 "difficulty swallowing"
      a_3 "painful swallowing"
      a_4 "lump or tightness in throat (globus)"
      a_5 "hiccups"
      a_6 "chest pain"
      a_7 "heartburn"
      a_8 "regurgitation"
      a_9 "bloating"
      a_10 "nausea"
      a_11 "vomiting / retching "
      a_12 "hoarseness"
      a_13 "cough"
      a_14 "shortness of breath"
      a_15 "ear ache/pain"
      a_16 "belching"
      a_17 "burning in throat"
      a_18 "thick saliva"
      a_19 "excessive saliva"
      a_20 "mucous production"
      a_21 "other"
      a_22 "No symptoms", :is_exclusive => true 
    
    repeater "Other Symptoms" do
    dependency :rule => "A"
    condition_A :q_ec_fu_symptoms1, "==", :a_21
      q_ec_fu_symptoms2 "Symptom"
      a_1 "Symptom", :string
    end
  end
 
  section "Medication / Lifestyle Follow Up" do 

    repeater "Current Medication regimen" do    
      q_ec_fu_medication1 "Medication", :pick=> :one, :display_type => :dropdown
        a_0 "None"
        a_1 "Dexlansoprazole (Kapidex)"
        a_2 "Esomeprazole (Nexium)"
        a_3 "Lansoprazole (Prevacid)"
        a_4 "Omeprazole (Prilosec)"
        a_5 "Omeprazole, Sodium Bicarbonate (Zegerid)"
        a_6 "Pantoprazole (Protonix)"
        a_7 "Rabeprazole (Aciphex)"
        a_8 "Other", :string
	
      q_ec_fu_medication2 "Dose (mg)"
        a :string
      
      q_ec_fu_medication3 "Frequency", :pick => :one, :display_type => :dropdown
        a_1 "Daily (AM)"
        a_2  "Daily (PM)"
        a_3 "Twice daily"
    end

    q_ec_fu_medication4  "Are you currently taking your medications  30-60 minutes before meals?", :pick => :one
      a_0 "No"
      a_1 "Yes"

    q_ec_fu_lifestyle1  "Are you currently doing any of the following?", :pick => :any
      a_1 "Elevation of head of bed (6 inch blocks under bed frame)" 
      a_2 "Avoiding meals 3 hours before bedtime" 
      a_3 "Avoiding food/substances that aggravate symptoms"
      a_4 "Sleeping on your left side"
      a_8 "None", :is_exclusive => true

  end 
 
  section "Plan" do

    q_ec_fu_plan1 "Anti-reflux medication change", :pick => :one
      a_1  "No change in dose"
      a_2  "Increased dosing interval of current medication to twice daily"
      a_3  "Stopped medication  (proton pump inhibitor)"
      a_4  "Not applicable"

    q_ec_fu_plan2  "Plan", :pick => :any
      a_1 "Manometry during clinic visit"
      a_2 "pH monitoring"
      a_3 "EGD"
      a_4 "pH-Impedence"
      a_5 "Other", :string
  end
  section "Comments" do
   q_ec_clinic_com1 "Additional Comments",:is_mandatory=>false
    a_1 :text
  end
end
