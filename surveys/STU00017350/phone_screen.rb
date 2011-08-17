survey "Phone Screen",:irb_number=>"STU00017350" do
  section "Phone Screen" do
    repeater "Phone call attempts" do
      q_caller "Caller"
      a :string
      
      q_date "Date/Time"
      a :datetime, :custom_class => 'timepicker'
      
      q_outcome "Outcome ", :pick => :one, :display_type => :dropdown
      a_left_message "left voicemail"
      a_left_message_with_person "left message"
      a_busy "busy"
      a_no_answer "no answer"
      a_completed "completed"
      a_other "other"

      q_notes "Notes",:is_mandatory=>false
      a :string
      
    end
    
    label "Ok great, I am now going to ask you a few questions to see if you are eligible for the study.  
    We ask these questions of all potential participants; some may apply to you, and some may not.  
    The answers to all questions will be kept confidential. ", 
    :help_text => "<i>If YES continue with script. If NO, thank them for showing interest in the 
    study and ask if we may keep their contact information for recruitment for future studies</i>"

    q_plan_living_in_chicago "Plan on living in Chicago area for the next 12 months?", :pick => :one,:custom_class => "custom_marging",:score_code=>"eligibility"
    a_yes "Yes"
    a_no "No",:weight=>1
    
    label "I am now going to ask you some questions about your physical health and any conditions that 
    may be monitored by a physician. Some of these questions may not apply to you, but we ask them of all potential participants:"
    
    label "<b>Medical Information</b>"
    
    q_height "Height (inches):"
    a :string
    
    q_weight "Weight (pounds):"
    a :string
    
    q_bmi "BMI: (28 - 40.4)", 
    :help_text =>"BMI = lbs*703/(inches*inches)"
    a "BMI", :float
    
    label "<a href=\"http://www.nhlbisupport.com/bmi/\" target=\"_blank\">BMI Calculator</a>" 
    
    label "I’m going to go through a list of several medical conditions and symptoms.  Please say yes or no for each one I ask you:  
    <b>If yes to any questions, ask and document follow-up responses.</b>"
    
    q_diabetes "Diabetes", :pick => :one, :help_text => "If yes, refer to decision trees"
    a_yes "Yes"
    a_no "No"

    q_diabetes_d_tree "Does diabetes decision tree rule them out?",:pick=>:one,:score_code=>"eligibility"
    a_1 "Yes",:weight=>1
    a_2 "No"

    q_diabetes_notes "Notes",:is_mandatory=>false
    a :string
    
    q_high_blood_preassure "High blood pressure?", :pick => :one, :help_text => "If yes, refer to decision trees"
    a_yes "Yes"
    a_no "No"

    q_hbp_d_tree "Does High blood preasure decision tree rule them out?", :pick=>:one,:score_code=>"eligibility"
    a_1 "Yes",:weight=>1
    a_2 "No"
    
    q_high_blood_preassure_notes "Notes",:is_mandatory=>false
    a :string

    q_heart_attack "Heart attack within the past year?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
    
    q_heart_attack_notes "Notes",:is_mandatory=>false
    a :string
  
    q_stroke "Stroke or symptoms of stroke in the past year?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"

    q_stroke_notes "Notes",:is_mandatory=>false
    a :string

    q_cancer "Cancer undergoing active treatment?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"

    q_cancer_notes "Notes",:is_mandatory=>false
    a :string

    q_pacemaker "Pacemaker?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"

    q_pacemaker_notes "Notes",:is_mandatory=>false
    a :string

    q_hypothyroidism "Hypothyroidism?", :pick => :one
    a_yes "Yes"
    a_no "No"

    q_hypothyroidism_notes "Notes",:is_mandatory=>false
    a :string

    q_hypothyroidism_controlled "<i>Is it controlled?</i>", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes"
    a_no "No",:weight=>1
    dependency :rule => "J"
    condition_J :q_hypothyroidism, "==", :a_yes    

    q_hypothyroidism_controlled_notes "Notes",:is_mandatory=>false
    a :string
    dependency :rule => "J"
    condition_J :q_hypothyroidism, "==", :a_yes

    q_plantar_fasciitis "Plantar fasciitis?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"

    q_plantar_fasciitis_notes "Notes",:is_mandatory=>false
    a :string

    q_crohns_disease "Crohn’s disease?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"

    q_crohns_disease_notes "Notes",:is_mandatory=>false
    a :string

    q_sleep_apnea "Sleep apnea?", :pick => :one
    a_yes "Yes"
    a_no "No"

    q_sleep_apnea_notes "Notes",:is_mandatory=>false
    a :string

    q_sleep_apnea_cpap_machine "<i>Do you use a CPAP machine at night?</i>", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
    dependency :rule => "O"
    condition_O :q_sleep_apnea, "==", :a_yes
    
    q_sleep_apnea_cpap_machine_notes "Notes",:is_mandatory=>false
    a :string
    dependency :rule => "O"
    condition_O :q_sleep_apnea, "==", :a_yes    

    q_asthma_or_breathing_problems "Do you have asthma or other breathing problems?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"

    q_asthma_or_breathing_problems_notes "Notes",:is_mandatory=>false
    a :string

    label "<b>In the last 30 days have you had:</b>", :help_text => "(if yes to any of the following, get medical clearance)"

    q_irregular_heartbeat "Irregular heartbeat?", :pick => :one
    a_yes "Yes"
    a_no "No"

    q_irregular_heartbeat_notes "Notes",:is_mandatory=>false
    a :string
    
    q_chest_pressure "Chest pressure?", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_chest_pressure_notes "Notes",:is_mandatory=>false
    a :string
    
    q_shortness_of_breath "Shortness of breath in regular daily activity?", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_shortness_of_breath_notes "Notes",:is_mandatory=>false
    a :string
            
    q_heart_fluttering "Heart fluttering?", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_heart_fluttering_notes "Notes",:is_mandatory=>false
    a :string
    
    q_cough_on_exertion "Cough on exertion?", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_cough_on_exertion_notes "Notes",:is_mandatory=>false
    a :string
    
    q_swollen_stiff_painful_joints "Swollen, stiff, or painful joints?", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_swollen_stiff_painful_joints_notes "Notes",:is_mandatory=>false
    a :string
    
    q_swollen_ankles_legs "Swollen ankles, legs, etc.?", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_swollen_ankles_legs_notes "Notes",:is_mandatory=>false
    a :string
        
    
    q_physical_activity "Has a doctor ever advised you <b>not</b> to participate in certain forms of physical activity?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
    
    q_physical_activity_notes "Notes",:is_mandatory=>false
    a :string
    
    q_any_pain "Do you experience any pain that prohibits you from engaging in moderate intensity physical activity?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
        
    q_any_pain_notes "Notes",:is_mandatory=>false
    a :string
    
    q_assistive_device "Do you use an assistive device for mobility? For example, a wheelchair or a cane?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
        
    q_assistive_device_notes "Notes",:is_mandatory=>false
    a :string
    
    q_hospitalized_for_phychiatric_reason "Have you been hospitalized for a psychiatric reason in the past 5 years?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
    
    q_hospitalized_for_phychiatric_reason_notes "Notes",:is_mandatory=>false
    a :string
    
    q_weight_loss_medication "Are you currently taking any weight-loss medications?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
    
    q_weight_loss_medication_notes "Notes",:is_mandatory=>false
    a :string
    
    q_diet "Are you currently following a structured diet program?", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_diet_notes "Notes",:is_mandatory=>false
    a :string
    
    q_diet_stopping "<i>To participate in this study, you would not be allowed to be on another weight loss program. Would you be willing to stop following your current program if you were enrolled in our study?</i>", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes"
    a_no "No",:weight=>1
    dependency :rule => "A"
    condition_A :q_diet, "==", :a_yes    
       
    q_diet_stopping_notes "Notes",:is_mandatory=>false
    a :string
    dependency :rule => "A"
    condition_A :q_diet, "==", :a_yes
    
    
    q_pregnant_or_nursing "Are you pregnant, trying to get pregnant, or lactating?", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
    a_na "NA"
    
    q_pregnant_or_nursing_notes "Notes",:is_mandatory=>false
    a :string
    
    q_medications "Are you currently taking any prescription medications?", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_medications_notes "Notes",:is_mandatory=>false
    a :string
    
    label "If yes, please list medication and reason for taking."
    dependency :rule => "A"
    condition_A :q_medications, "==", :a_yes
    
    repeater "List of Medications" do
      dependency :rule => "A"
      condition_A :q_medications, "==", :a_yes      
      q_exluded_medication "Medication", :pick => :one, :display_type => :dropdown
      a "Abilify (aripiprazole)"
      a "aripiprazole (Abilify)"
      a "chlorpromazine (Thorazine)"
      a "clozapine (Clozaril)"
      a "Clozaril (clozapine)"
      a "fluphenazine (Prolixin)"
      a "Geodon (ziprasidone)"
      a "Haldol (haloperidol)"
      a "haloperidol (Haldol)"
      a "loxapine (Loxitane)"
      a "Loxitane (loxapine)"
      a "Mellaril (thioridazine)"
      a "mesoridazine (Serentil)"
      a "Moban (molindone)"
      a "molindone (Moban)"
      a "Navane (thiothixene)"
      a "olanzapine (Zyprexa)"
      a "Orap (pimozide)"
      a "perphenazine (Trilafon)"
      a "pimozide (Orap)"
      a "Prolixin (fluphenazine)"
      a "quetiapine (Seroquel)"
      a "Risperdal (risperidone)"
      a "risperidone (Risperdal)"
      a "Serentil (mesoridazine)"
      a "Seroquel (quetiapine)"
      a "Stelazine (trifluoperazine)"
      a "thioridazine (Mellaril)"
      a "thiothixene (Navane)"
      a "Thorazine (chlorpromazine)"
      a "trifluoperazine (Stelazine)"
      a "Trilafon (perphenazine)"
      a "ziprasidone (Geodon)"
      a "Zyprexa (olanzapine)"
      a "Invega (Paliperidone)"
      a "Paliperidone (Invega)"
      a "Prednisone (Deltasone"
      a "carbamazepine (Tegretol,Equetro)"
      a "Depakote (divalproex)"
      a "divalproex (Depakote)"
      a "Equetro (carbamazepine,Tegretol)"
      a "Eskalith (lithium carbonate)"
      a "gabapentin (Neurontin)"
      a "Gabitril (tiagabine)"
      a "Lamictal (lamotrigine)"
      a "lamotrigine (Lamictal)"
      a "lithium carbonate (Eskalith, Lithonate)"
      a "Lithonate (lithium carbonate,Eskalith)"
      a "Neurontin (gabapentin)"
      a "olanzapine (Symbyax)"
      a "oxcarbazepine (Trileptal)"
      a "Symbyax (olanzapine+fluoxetine)"
      a "Tegretol (carbamazepine)"
      a "tiagabine (Gabitril)"
      a "Topamax (topiramate)"
      a "topiramate (Topamax)"
      a "Trileptal (oxcarbazepine)"
      a "5 HTP"
      a "Hoodia"  
      a "Chitosan"  
      a "Leptoprin" 
      a "Acutrim" 
      a "Deep"  
      a "Phentermine"
      a "Dietrine Carb Blocker"
      a "Lipo 6x"
      a "Hydroxycut"  
      a "Alli"  
      a "Cuur"  
      a "Stacker"
      a "Dexatrim"
      a "Herbal Phen-Fen"
      a "PhenTrim"
      a "Phen-Cal"
      a "Xenadrine"
      a "Lipovox"
      a "Phenterfein"
      a "Zalestrim"
      a "Myoffeine"
      a "SomnaSlim PM"
      a "72 Hour Diet Pill"
      a "Adipex-P (phentermine, Ionamin)"
      a "adipost (Bontril)"
      a "benzphetamine (Didrex)"
      a "Bontril (adipost)"
      a "Didrex (benzphetamine)"
      a "diethylpropion  (Tenuate, Dospan)"
      a "Dospan (diethylpropion, Tenuate)"
      a "Ionamin (phentermine)"
      a "Mazanor (mazindol, Sanorex)"
      a "mazindol  (Sanorex, Mazanor)"
      a "Meridia (sibutramine)"
      a "orlistat  (Xenical)"
      a "phendimetrazine (Plegine)"
      a "phentermine (Ionamin, Adipex-P)"
      a "Plegine (phendimetrazine)"
      a "Sanorex (mazindol)"
      a "sibutramine (Meridia)"
      a "Tenuate (diethylpropion)" 
      a "Xenical (orlistat)"
      a "Adapin (doxepin)"
      a "amitriptyline (Elavil, Endep)"
      a "Anafranil (clomipramine)"
      a "clomipramine (Anafranil)"
      a "desipramine (Norpramin, Pertofrane)"
      a "dosulepin (dothiepin) (Prothiaden)"
      a "doxepin (Adapin, Sinequan)"
      a "Elavil (amitriptyline)"
      a "Endep (amitriptyline, Elavil)"
      a "imipramine (Tofranil)"
      a "lofepramine (Gamanil)"
      a "Gamanil (lofepramine)"
      a "Norpramin (desipramine)"
      a "Pertofrane (desipramine, Norpramin)"
      a "Prothiaden (dosulepin (dothiepin))"
      a "protriptyline (Vivactil)"
      a "Remeron (mirtazapine)"
      a "mirtazapine (Remeron)"
      a "Sinequan (doxepin; Adapin)"
      a "Surmontil (trimipramine)"
      a "Tofranil  (imipramine)"
      a "trimipramine (Surmontil)"
      a "nortriptyline (Pamelor, Aventyl HCl)"
      a "Aventytl HCl (nortriptyline, Pamelor)"
      a "Pamelor (nortriptyline)"
      a "Vivactil (protriptyline)"
         
      q "Reason for use"
      a :string
      q "Dosage"
      a :string
      q "Frequency"
      a :string
    end    
    
    q_medications_selected "Are any of the above medications selected from the list", :pick => :one,:score_code=>"eligibility"
    a_yes "Yes",:weight=>1
    a_no "No"
    dependency :rule => "A"
    condition_A :q_medications, "==", :a_yes
     
    repeater "Medications -- Other" do
      dependency :rule => "A"
      condition_A :q_medications, "==", :a_yes
      q_medications_other "Medications"
      a :string
      q "Reason for use"
      a :string
      q "Dosage"
      a :string
      q "Frequency"
      a :string 
    end
  
    group "Not Eligible" do 
      dependency :rule => "A or B or C or D or E or F or G or H or I or (J and K) or L or M or N or O or P or R or S or T or (U and V) or W or (X and Y)"
      condition_A :q_plan_living_in_chicago, "==", :a_no    
      condition_B :q_bmi, "<", {:float_value => "28.0"} 
      condition_C :q_bmi, ">", {:float_value => "40.4"}    
      condition_D :q_diabetes, "==", :a_yes
      condition_E :q_high_blood_preassure, "==", :a_yes
      condition_F :q_heart_attack, "==", :a_yes
      condition_G :q_stroke, "==", :a_yes
      condition_H :q_cancer, "==", :a_yes
      condition_I :q_pacemaker, "==", :a_yes
      condition_J :q_hypothyroidism, "==", :a_yes
      condition_K :q_hypothyroidism_controlled, "==", :a_no
      condition_L :q_plantar_fasciitis, "==", :a_yes
      condition_M :q_crohns_disease, "==", :a_yes            
      condition_N :q_sleep_apnea_cpap_machine, "==", :a_yes
      condition_O :q_physical_activity, "==", :a_yes
      condition_P :q_any_pain, "==", :a_yes
      condition_R :q_assistive_device, "==", :a_yes
      condition_S :q_hospitalized_for_phychiatric_reason, "==", :a_yes
      condition_T :q_weight_loss_medication, "==", :a_yes
      condition_U :q_diet, "==", :a_yes
      condition_V :q_diet_stopping, "==", :a_no
      condition_W :q_pregnant_or_nursing, "==", :a_yes
      condition_X :q_medications, "==", :a_yes
      condition_Y :q_medications_selected, "==", :a_yes
      
      label "It looks like you are <b>not</b> eligible for this specific study at the time."
            
      q_keep_contact "Would you like us to keep your contact information in our department’s database for future studies?", :pick => :one
      a_yes "Yes"
      a_no "No"
      
      q_local_weight_loss_options "Would you like any referrals for other local weight-loss options?", :pick => :one
      a_yes "Yes"
      a_no "No"      
      
      q_reason "Any additional Notes",:is_mandatory=>false
      a :text
    end
  end
end
