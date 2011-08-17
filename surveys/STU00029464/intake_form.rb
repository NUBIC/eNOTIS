survey "Intake Information – Esophageal Center",:irb_number=>"STU00029464" do
  
  section "Identifying information" do 

    q_ec_identify1 "Study ID"
      a_1 :string

    q_ec_identify2  "Referring Physician" 
      a_1 "First", :string
      a_2 "Last", :string

    q_ec_identify3 "Referring Physician Location", :pick => :one
      a_1 "NMFF"
      a_2 "NMPG"
      a_3 "Other", :string

    q_ec_identify4 "Medical Record Numbers", :pick => :any 
      a "FIN", :string
      a "MRN", :string

  end

  section "Other Demographic information" do 
    q_ec_demo1 "What is your current marital status?", :pick => :one
      a_1 "Married, or living as married"
      a_2 "Widowed"
      a_3 "Divorced"
      a_4 "Separated"    
      a_5 "Single"
    
    q_ec_demo2 "What is your highest level of education completed?", :pick => :one
      a_1 "Less than high school"
      a_2 "High School / GED"
      a_3 "Some College"
      a_4 "Associate’s Degree"    
      a_5 "College Degree" 
      a_6 "Master’s Degree"
      a_7 "Graduate Degree (M.D./Ph.D/J.D.)"
   
    q_ec_demo3  "What is your annual household income from all sources?", :pick=>:one
      a_1 "Less than $10,000"
      a_2 "$10,000 to less than $20,000"
      a_3 "$20,000 to less than $30,000"
      a_4 "$30,000 to less than $40,000"
      a_5 "$40,000 to less than $5,0000"
      a_6 "$50,000 to less than $60,000"
      a_7 "$60,000 to less than $70,000"
      a_8 "$70,000 to less than $80,000"
      a_9 "$80,000 to less than $90,000"
      a_10 "$90,000 to less than $100,000"
      a_11 "$100,000 or higher"
      a_12 "Not answered"
  end

  section "Medical History" do
    
    q_ec_medhx1 "When were you diagnosed with gastroesophageal reflux disease (GERD)?",:pick=> :one, :display_type => :dropdown
      (60.years.ago.year..2012).to_a.reverse.each{|year| a year.to_s}

    q_ec_medhx2 "Have you ever had an upper endoscopy?", :pick=>:one
      a_0 "No"
      a_1 "Yes"

    q_ec_medhx3 "Most recent endoscopy date",:pick => :one, :display_type => :dropdown 
    (100.years.ago.year..1.minute.ago.year).to_a.reverse.each{|year| a year.to_s}
    dependency :rule => "A"
    condition_A :q_ec_medhx2, "==", :a_1

    q_ec_medhx4 "Location", :pick => :one, :display_type => :dropdown
      a_1 "NMH"
      a_2 "Other" 
    dependency :rule => "A"
    condition_A :q_ec_medhx2, "==", :a_1


    q_ec_medhx5 "Have you had or do you currently have any of the following medical problems?", :pick=>:any
      a_1 "Asthma"
      a_2 "Chronic obstructive pulmonary disease (COPD)/emphysema"
      a_3 "Congestive heart failure"
      a_4 "Coronary artery disease"
      a_5 "Hypertension (on medication)"
      a_6 "Hyperlipidemia / High cholesterol"
      a_7 "Myocardial infarction "
      a_8 "Cerebral vascular accident (CVA) / Stroke"
      a_9 "Cancer (prior or current)"
      a_10 "Diabetes (on insulin)"
      a_11 "Diabetes (oral therapy, not on insulin)"
      a_12 "Diabetes (no medication)"
      a_13 "None of the Above", :is_exclusive=>true
    
    repeater "Medical History" do
      q_ec_medhx6 "Diagnosis", :custom_class => "medhx",:is_mandatory=>false
        a :string

      q_ec_medhx7 "Date diagnosed", :custom_class => "medhx",:pick=>:one,:display_type => :dropdown,:is_mandatory=>false
        (100.years.ago.year..1.minute.ago.year).to_a.reverse.each{|year| a year.to_s}

      q_ec_medhx8 "Status", :pick => :one, :display_type => :dropdown, :custom_class => "medhx",:is_mandatory=>false
        a_1 "Chronic / Active"
        a_2 "Resolved"
    end
 
    q_ec_medhx9  "Has a doctor or other healthcare provider EVER told you that you have a depressive disorder (including depression, major depression, dysthymia, or minor depression)?", :pick=>:one
      a_0 "No"
      a_1 "Yes"
      a_8 "Not answered"

    q_ec_medhx10  "Has a doctor or other healthcare provider EVER told that you had an anxiety disorder (including acute stress disorder, anxiety, generalized anxiety disorder, obsessive compulsive disorder, panic disorder, phobia, posttraumatic stress disorder, or social anxiety disorder)?", :pick=>:one
      a_0 "No"
      a_1 "Yes"
      a_8 "Not answered"

  end

 section "Surgical History" do
    q_ec_surghx1 "Have you ever had gastrointestinal surgery?", :pick => :one
      a_0 "No"
      a_1 "Yes"

    repeater "GI Surgical History" do
    dependency :rule => "A"
    condition_A :q_ec_surghx1, "==", :a_1
      q_ec_surghx2 "Surgery", :pick => :one, :display_type => :dropdown, :custom_class => "surghx"
        a_0 "None"    
        a_1 "Fundoplication"
        a_2 "Heller Myotomy"
        a_3 "Trans-hiatal esophagectomy"
        a_4 "Gastric Bypass"    
        a_5 "Dor"  
        a_6 "Toupet"
        a_7 "Watson"    
        a_8 "Belsey Mark IV r"
        a_9 "Elf"
      
      q_ec_surghx3 "Other Surgery", :custom_class => "surghx"
        a_1 :string

      q_ec_surghx4 "Year", :pick => :one, :display_type => :dropdown, :custom_class => "surghx"
      (100.years.ago.year..1.minute.ago.year).to_a.reverse.each{|year| a year.to_s}
      
      q_ec_surghx5 "Location", :pick => :one, :display_type => :dropdown, :custom_class => "surghx"
        a_1 "NMH"
        a_2 "Other" 
    end
  end

  section "Allergies" do

    repeater "Allergies" do
      q_ec_allergy1 "Allergen", :custom_class => "allergy",:is_mandatory=>false
        a :string
      
      q_ec_allergy2 "Reaction", :pick => :one, :display_type => :dropdown, :custom_class => "allergy",:is_mandatory=>false
        a_1 "adverse reaction"
        a_2 "mild"
        a_3 "severe"
        a_4 "anaphylaxis"
    end
  end
  section "Smoking History" do
    q_ec_smoke1  "Have you smoked at least 100 cigarettes (5 packs) in your entire life?", :pick => :one
      a_0 "No"
      a_1 "Yes"
      a_8 "Not answered"

    q_ec_smoke2 "Do you currently smoke cigarettes?", :pick => :one
      a_0 "No"
      a_1 "Yes"
      a_8 "Not answered"
    
    q_ec_smoke3 "On average, about how many cigarettes a day do you now smoke?", :pick => :one
      a_1 "Cigarettes per day", :string
      a_8 "Not answered"
    dependency :rule => "A"
    condition_A :q_ec_smoke2, "==", :a_1
  end
  section "Alcohol Consumption" do
    q_ec_alcohol1 "In any one year, have you had at least 12 drinks of any type of alcoholic beverage? A drink is a 12oz. beer, a 5oz. glass of wine, one and half ounces of liquor.", :pick => :one
      a_0 "No"
      a_1 "Yes"
      a_8 "Not answered" 

    q_ec_alcohol2 "In the past 12 months, how often did you drink any type of alcoholic beverage?", :pick => :one
      a_1 "Every day"
      a_2 "Several times per week"
      a_3 "Several times per month"
      a_4 "Once a month or less"
      a_5 "Never"
      a_8 "Not answered"
    
    q_ec_alcohol3 "In the past 12 months, on those days that you drank alcoholic beverages, on average, how many drinks did you have?", :pick => :one
      a_0  "0"
      a_1 "1-2"
      a_2 "3-4"
      a_3 "5-6"
      a_4 "7-8"
      a_5 "9-10"
      a_6 "More than 10"
      a_8 "Not answered"
  end
 
 section "Current Symptoms" do
    q_ec_symptoms1 "What symptoms have you experienced in the past 7 days?", :pick => :any
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
    condition_A :q_ec_symptoms1, "==", :a_21
      q_ec_symptoms2 "Symptom"
        a_1 "Symptom", :string
    end
  end
  
  section "Current Medications" do
    repeater "Medications" do
      q_ec_medication1 "Medications", :pick => :one, :display_type => :dropdown, :custom_class => "meds",:is_mandatory=>false
        a_1 "Dexlansoprazole (Kapidex)"
        a_2 "Esomeprazole (Nexium)"
        a_3 "Lansoprazole (Prevacid)"
        a_4 "Omeprazole (Prilosec)"
        a_5 "Omeprazole, Sodium Bicarbonate (Zegerid)"
        a_6 "Pantoprazole (Protonix)"
        a_7 "Rabeprazole (Aciphex)"    
        a_8 "Cimetidine (Tagamet)"
        a_9 "Famotidine (Pepcid)"
        a_10 "Nizatidine (Axid)"
        a_11 "Ranitidine (Zantac)"
        a_12 "Metoclopramide (Reglan)"
        a_13 "Baclofen (Lioresal)"
      
      q_ec_medication2 "Dose (mg)", :custom_class => "meds"
        a "|mg", :string
      
      q_ec_medicaton3 "Frequency", :pick => :one, :display_type => :dropdown, :custom_class => "meds",:is_mandatory=>false
        a_1 "Daily (AM)"
        a_2 "Daily (PM)"
        a_3 "Daily (bedtime)"
        a_3 "Twice daily"
        a_4 "Three times daily"

      q_ec_medication5 "Other frequency", :custom_class => "meds",:is_mandatory=>false
        a_1 :string

    end 
  end 

  section "Intervention" do
    
    q_ec_intervene1  "Study group", :pick=>:one
      a_1  "Control group"
      a_2 "Intervention group"

    q_ec_intervene2 "Counseled patient on the following lifestyle modifications", :pick => :any
      a_1 "Elevate head of bed (6 inch blocks under bed frame)" 
      a_2 "Do not eat 3 hours before bedtime" 
      a_3 "Avoid food/substances that aggravate symptoms"
      a_4  "Sleep on your left side"
      a_8 "No instructions given", :is_exclusive => true

    q_ec_intervene3 "Proton pump inhibitor change", :pick => :one
      a_1  "No change in dose"
      a_2  "Increased dosing interval of current medication to twice daily"

    repeater "Medication regimen (PPI)" do    
      q_ec_intervene4 "Medication", :pick=> :one, :display_type => :dropdown
        a_0 "None"
        a_1 "Dexlansoprazole (Kapidex)"
        a_2 "Esomeprazole (Nexium)"
        a_3 "Lansoprazole (Prevacid)"
        a_4 "Omeprazole (Prilosec)"
        a_5 "Omeprazole, Sodium Bicarbonate (Zegerid)"
        a_6 "Pantoprazole (Protonix)"
        a_7 "Rabeprazole (Aciphex)"
        a_8 "Other", :string

      q_ec_intervene5 "Dose (mg)"
        a :string
      
      q_ec_intervene6 "Frequency", :pick => :one, :display_type => :dropdown
        a_1 "Daily (AM)"
        a_2  "Daily (PM)"
        a_3 "Twice daily"
    end

    q_ec_intervene7 "Counseled patient on proper dosing and administration of PPI therapy – 30-60minutes before meals", :pick => :one
      a_0 "No"
      a_1 "Yes"
    q_ec_intervene8 "Patient verbalized understanding of instructions including medication administration, dosing, and lifestyle modifications", :pick => :one
      a_0 "No"
      a_1 "Yes"
      a_3 "Not applicable"
  end

  section "Plan" do
    q_plan1 "Esophageal Center Physician", :pick => :one,:display_type=>"dropdown"
      a_1 "Brenner"
      a_2 "Ferreira"
      a_3 "Gonsalves"
      a_4 "Hirano"
      a_5 "Howden"
      a_6 "Kahrilas"
      a_7 "Komdanduri"
      a_8 "Pandolfino"
      a_9 "Stevoff"
      a_10 "Vanagunas"

    q_plan2 "Follow up appointment date and time"
      a :datetime, :custom_class => 'timepicker'

    q_plan3 "Tentative plan", :pick => :any
      a_1 "Manometry during clinic visit"
      a_2 "pH monitoring"
      a_3 "EGD"
      a_4 "Other", :string


    q_plan4 "Pharmacy"
      a_1 :string

    q_plan5 "Pharmacy phone number"
      a_1 :string  
  end
  section "Comments" do
   q_ec_intake_com1 "Additional Comments",:is_mandatory=>false
    a_1 :text
  end
end

