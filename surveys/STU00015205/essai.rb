survey "Eosinophilic Esophagitis Activity Index (EEsAI)",:irb_number=>'STU00015205' do 
  section "General Questions" do
    q_essai_gq_1 "Who is completing this questionnaire?",:pick=>:one
      a_1 "patient himself / herself"
      a_2 "spouse or partner"
      a_3 "Other", :string
  
    q_essai_gq_2 "What is your year of birth?"
      a :integer

    q_essai_gq_3 "What is your gender?",:pick=>:one
      a_1 "male"
      a_2 "female"
    q_essai_gq_4 "Are you...",:pick=>:one
      a_1 "Hispanic or Latino"
      a_2 "Not Hispanic/Latino"
    q_essai_gq_5 "What is your racial background?",:pick=>:any
      a_1 "American Indian or Alaska Native"
      a_2 "Asian"
      a_3 "White/Caucasian"
      a_4 "Native Hawaiian or Other Pacific Islander"
      a_5 "Black or African American"
      a_6 "more than one race (please select each"
    
    q_essai_gq_6 "What is the highest grade or year of school that you have completed?",:pick=>:one,:display_type=>"dropdown"
      a_1 "1st grade"
      a_2 "2nd grade"
      a_3 "3rd grade"
      a_4 "4th grade"
      a_5 "5th grade"
      a_6 "6th grade"
      a_7 "7th grade"
      a_8 "8th grade"
      a_9 "9th grade"
      a_10 "10th grade"
      a_11 "11th grade"
      a_12 "12th grade"
      a_13 "high school diploma/equivalent"
      a_14 "voc/tec program after high school but no voc/tec diploma"
      a_15 "voc/tec program after high school, diploma"
      a_16 "some college but no degree"
      a_17 "associate’s degree"
      a_18 "bachelor’s degree"
      a_19 "graduate or professional school but no degree"
      a_20 "master’s degree (MA/MS)"
      a_21 "doctorate degree (PHD, EDD)"
      a_22 "professional degree after bachelor’s degree (medicine/MD; dentistry/DDS; law/JD/LLB; ect.)"
      a_23 "refused"
      a_24 "don't know"
  end

  section "Health Questions" do 

    q_assai_health_1 "How are you in general?",:pick=>:one
      a_1 "you are fully active and more or less as you were before your illness"
      a_2 "you cannot carry out heavy physical work, but can do anything else"
      a_3 "you are up and about more than half the day; you can look after yourself, but are not well enough to work"
      a_4 "you are in bed or sitting in a chair for more than half the day; you need some help in looking after yourself"
      a_5 "you are in bed or a chair all the time and need a lot of care by other people"

    q_assai_health_2  "Please think of all your symptoms due to eosinophilic esophagitis and make an overall statement by selecting one of the numbers. On a scale from 0 to 10 (0 being no symptoms, 10 being most severe), how severe are your eosinophilic esophagitis symptoms today?",:pick=>:one,:display_type=>"slider"
    (1..10).to_a.each{|num| a num.to_s}

    q_assai_health_3 "To what extent have you been impaired in your social activities (for example daily life where you eat with friends or family) by your eosinophilic esophagitis in the past 30 days?",:pick=>:one,:help_text=>"Please think of all problems that are caused by eosinophilic esophagitis and that reduce your quality of life and make an over-all statement by circling one of the numbers."
      (1..10).to_a.each{|num| a num.to_s}

    q_assai_health_4 "When in your life did you first notice problems related to eosinophilic esophagitis?",:pick=>:one
      a_1 "Never"
      a_2 "Less than 1 month ago"
      a_1 "1 to 3 months ago"
      a_1 "4 to 11 months ago"
      a_1 "1 to 5 years ago"
      a_1 "more than 5 years ago"

    q_essai_12 "Do you have difficulties chewing?",:help_text=>"(for example your tooth needs filling, or you have false teeth, or your jaw is injured)?",:pick=>:one
      a_1 "No"
      a_2 "Yes"
    q_12a "Why?"
      a :string
      dependency :rule => "A"
      condition_A :q_essai_12, "==", :a_1

    q_13 "In the past 30 days, <strong>what kind of food typically caused trouble swallowing?</strong>"
      a :text



    label "Please tell us now about your regular eating habits!" 

    grid_14 "Today, how difficult would it be to swallow the foods shown below? <br/> Please imagine you ate those foods now and tell us what would typically happen. <br/> Important: please imagine eating it without modification such as blending, mashing, cutting in tiny pieces, dunking in liquid!" do 
      a_1 "Severe difficulties (for example: will not pass at all)"
      a_2 "Moderate difficulties (for example: will need to wash down with liquid)"
      a_3 "Mild difficulties (for example: will pass with further swallows)"
      a_4 "No difficulties"
      a_5 "Don’t know"

      image_14a "surveyor/STU00020973/solid_meat.png",:help_text=>"Solid Meat (steak, chicken, turkey, lamb)",:pick=>:one
      image_14b "surveyor/STU00020973/soft_foods.png",:help_text=>"Soft foods (pudding, jelly, apple sauce)",:pick=>:one
      image_14c "surveyor/STU00020973/dry_rice.png",:help_text=>"Dry rice (grains don‘t stick) or sticky Asian rice, without sauce",:pick=>:one
      image_14d "surveyor/STU00020973/ground_meat.png",:help_text=>"Ground meat (hamburger, meat loaf)",:pick=>:one
      image_14e "surveyor/STU00020973/bread.png",:help_text=>"Fresh white untoasted bread or similar foods (donut, muffin, cake)",:pick=>:one
      image_14f "surveyor/STU00020973/grits.png",:help_text=>"Grits, porridge, rice pudding",:pick=>:one
      image_14g "surveyor/STU00020973/raw.png",:help_text=>"Raw, fibrous foods, not grated (apple, carrot, celery)",:pick=>:one
      image_14h "surveyor/STU00020973/french_fries.png",:help_text=>"French fries without sauce or ketchup",:pick=>:one
    end
    grid "Now we would like to know, in the past 30 days, did you..." do 
      a_1 "modify this food? (for example: put it in blender, cut in tiny pieces, dunk in liquid, mash it)"
      a_2 "avoid this food altogether? (for example: because it would not pass at all)"
      a_3 "eat this food slower than others? (for example: because you chew very long)"

      image_14a "surveyor/STU00020973/solid_meat.png",:help_text=>"Solid Meat (steak, chicken, turkey, lamb)",:pick=>:one
      image_14b "surveyor/STU00020973/soft_foods.png",:help_text=>"Soft foods (pudding, jelly, apple sauce)",:pick=>:one
      image_14c "surveyor/STU00020973/dry_rice.png",:help_text=>"Dry rice (grains don‘t stick) or sticky Asian rice, without sauce",:pick=>:one
      image_14d "surveyor/STU00020973/ground_meat.png",:help_text=>"Ground meat (hamburger, meat loaf)",:pick=>:one
      image_14e "surveyor/STU00020973/bread.png",:help_text=>"Fresh white untoasted bread or similar foods (donut, muffin, cake)",:pick=>:one
      image_14f "surveyor/STU00020973/grits.png",:help_text=>"Grits, porridge, rice pudding",:pick=>:one
      image_14g "surveyor/STU00020973/raw.png",:help_text=>"Raw, fibrous foods, not grated (apple, carrot, celery)",:pick=>:one
      image_14h "surveyor/STU00020973/french_fries.png",:help_text=>"French fries without sauce or ketchup",:pick=>:one
    end

    q_essais_19 "In the past 30 days, how often have you had trouble swallowing (not associated with cold symptoms, such as sore throat)?",:pick=>:one
      a_1 "Never"
      a_2 "once to 3 times per month"
      a_3 "once to 3 times per week"
      a_4 "4 to 6 times per week"
      a_5 "daily"

    q_essai_20 "In the past 30 days, typically how intense was an episode of trouble swallowing?",:pick=>:one
      a_1 "everything was easy to swallow"
      a_2 "slight retching, swallowing problem spontaneously disappeared"
      a_3 "food was stuck in the throat (esophagus) for a short time (less than 5 minutes), needed to be washed down with liquid or required deep breathing or retching"
      a_4 "food was stuck in the throat (esophagus) for a long time (more than 5 minutes), but did not need to be removed by a physician"
      a_5 "impacted food had to be removed by a physician"

    q_essai_21 "In the past 30 days, <strong>typically how long did an episode of trouble swallowing last</strong>?",:pick=>:one
      a_1 "less than 15 seconds"
      a_2 "16 to 59 seconds"
      a_3 "1 to 5 minutes"
      a_4 "longer than 5 minutes"

    q_essai_22 "In the past 30 days,<strong> how long did it usually last to eat lunch,</strong> when the food was not soft boiled, cut in tiny pieces, blended, or mashed?",:pick=>:one
      a_1 "less than 15 min"
      a_2 "16 to 30 min"
      a_3 "31 to 45 min"
      a_4 "46 to 60 min"
      a_5 "longer than an hour or refusal to eat"


    grid_essai_23 "Some people have particular problems with liquids which are sour, sparkling (fizzy), or very cold. <br/> In the past 30 days, was it ever painful to drink" do 
      a_1 "Yes"
      a_2 "No"

      q_essai_23a "sour liquids, such as orange juice, white wine, alcoholic beverages",:pick=>:one
      q_essai_23b "sparkling liquids, such as coke, lemonade, ginger ale",:pick=>:one
      q_essai_23c "any kind of cold beverage (with ice)",:pick=>:one
    end

    q_essai_24 "In the past 30 days, was it painful to swallow?",:pick=>:one
      a_1 "never"
      a_2 "one to 3 times per month"
      a_3 "one to 3 times per week"
      a_4 "4 to 6 times per week"
      a_5 "daily"

    label "<strong>PAIN OR DISCOMFORT IN THE CHEST</strong> <br/> With the next two questions we want to find out if you feel sometimes pain or discomfort in your chest even between meals. There are two main types of or chest pain, and people can suffer from one or the other, or from both types of pain. Looking back over the past 30 days, did you experience one (or both) of the two types of pain which we now describe? We always mean pain occurring when you were not eating or drinking (e.g. apart from meals)?"

    q_essai_25 "The first type of chest pain we want to ask you about is the following:<br/>  Pain or discomfort behind the breast bone in the chest that stays constantly at the same place, and burns, itches or cramps. It occurs unforeseen, or when drinking wine, orange juice, coke or other acid beverages. Antacids don’t ease the pain (examples of antacids are: Amphojel®, Alternagel®, Gaviscon®, Maalox®, Mylanta®, Riopan®, Rolaids®, Tums®).<br/><strong> In the past 30 days, did you experience this kind of pain or discomfort?</strong>",:pick=>:one
      a_1 "Yes"
      a_2 "No"
      a_3 "Unsure please discuss it with your physician"

      group_essai_25a "How long did such an episode of pain or discomfort last?",:display_type=>"simple_table" do 
        dependency :rule => "A"
        condition_A :q_essai_25, "==", :a_1

        q_essai_25a1 "Seconds"
          a :integer,:default_value=>0
        q_essai_25a2 "Minutes"
          a :integer, :default_value=>0 
        q_essai_25a3 "Hours"
          a :integer, :default_value=>0
      end

    q_essai_25b "How often does this or did this pain or discomfort occur?",:pick=>:one
      a_1 "less than once a month"
      a_2 "about once a month"
      a_3 "about once a week"
      a_4 "several times a week"
      a_5 "daily"
      dependency :rule => "A"
      condition_A :q_essai_25, "==", :a_1     

    grid_essai_25c "In the past 30 days, how severe was your pain or discomfort?<br/> These faces show how much something can hurt. The first face on the left shows no pain. The further you look on the right, the more severe the pain gets." do 
      dependency :rule => "A"
      condition_A :q_essai_25, "==", :a_1
      a_1 "surveyor/STU00020973/discomfort_1.png",:display_type=>"image"
      a_2 "surveyor/STU00020973/discomfort_2.png",:display_type=>"image"
      a_3 "surveyor/STU00020973/discomfort_3.png",:display_type=>"image"
      a_4 "surveyor/STU00020973/discomfort_4.png",:display_type=>"image"
      a_5 "surveyor/STU00020973/discomfort_5.png",:display_type=>"image"
      a_6 "surveyor/STU00020973/discomfort_6.png",:display_type=>"image"

      q_25c1 "Choose the face that shows the worst pain you have experienced in the past 30 days.",:pick=>:one
    end

  q_essai_26 "The second type of chest pain we want to ask you about is the following: <br/> A burning chest pain or discomfort (heartburn), which travels up toward your throat (ascending). Together with the pain, people sometimes have a bitter or sour-tasting fluid coming up from the stomach into their mouth or throat, particularly when bending down, for example to tie their shoes. This pain usually gets better with antacids (examples of antacids: Amphojel®, Alternagel®, Gaviscon®, Maalox®, Mylanta®, Riopan®, Rolaids®, Tums®). <br/> In the past 30 days, did you experience the described symptoms?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    a_3 "Unsure please discuss it with your physician"
      group_essai_26a "How long did such an episode of pain or discomfort last?",:display_type=>"simple_table" do 
        dependency :rule => "A"
        condition_A :q_essai_26, "==", :a_1

        q_essai_26a1 "Seconds"
          a :integer,:default_value=>0
        q_essai_26a2 "Minutes"
          a :integer,:default_value=>0
        q_essai_26a3 "Hours"
          a :integer,:default_value=>0
      end

    q_essai_26b "How often does this or did this pain or discomfort occur?",:pick=>:one
      a_1 "less than once a month"
      a_2 "about once a month"
      a_3 "about once a week"
      a_4 "several times a week"
      a_5 "daily"
      dependency :rule => "A"
      condition_A :q_essai_26, "==", :a_1     

    grid_essai_26c "In the past 30 days, how severe was your pain or discomfort?<br/> These faces show how much something can hurt. The first face on the left shows no pain. The further you look on the right, the more severe the pain gets." do 
      dependency :rule => "A"
      condition_A :q_essai_26, "==", :a_1
      a_1 "surveyor/STU00020973/discomfort_1.png",:display_type=>"image"
      a_2 "surveyor/STU00020973/discomfort_2.png",:display_type=>"image"
      a_3 "surveyor/STU00020973/discomfort_3.png",:display_type=>"image"
      a_4 "surveyor/STU00020973/discomfort_4.png",:display_type=>"image"
      a_5 "surveyor/STU00020973/discomfort_5.png",:display_type=>"image"
      a_6 "surveyor/STU00020973/discomfort_6.png",:display_type=>"image"

      q_26c1 "Choose the face that shows the worst pain you have experienced in the past 30 days.",:pick=>:one
    end

   q_essai_26d "Do you experience acid regurgitation at least once a week?",:pick=>:one
     a_1 "Yes"
     a_2 "no"
      dependency :rule => "A"
      condition_A :q_essai_26, "==", :a_1

   grid "Have you ever been told by a doctor or an other health professional that…" do
     a_1 "Yes"
     a_2 "No"
     a_3 "Don't Know"
   
     q_essai_hp1 "...you had gastro-esophageal reflux?",:pick=>:one
     q_essai_hp2 "...you had asthma?",:pick=>:one
     q_essai_hp3 "...you had hay fever or other allergy-related nose problems (e.g. grass or flower pollen, weeds, dust mites, dogs, cats)?",:pick=>:one
     q_essai_hp4 "...you had eczema?",:pick=>:one
     q_essai_hp5 "...you had a food allergy?",:pick=>:one
   end

   q_essai_hp1a "Do you still have gastro esophageal reflux?",:pick=>:one
     a_1 "Yes"
     a_2 "No"
     a_3 "Don't Know"
     dependency :rule => "A"
     condition_A :q_essai_hp1, "==", :a_1

   q_essai_hp2a "Do you still have asthma?",:pick=>:one
     a_1 "Yes"
     a_2 "No"
     a_3 "Don't Know"
     dependency :rule => "A"
     condition_A :q_essai_hp2, "==", :a_1

   q_essai_hp3a "Do you still have hay fever?",:pick=>:one
     a_1 "Yes"
     a_2 "No"
     a_3 "Don't Know"
     dependency :rule => "A"
     condition_A :q_essai_hp3, "==", :a_1

   q_essai_hp4a "Do you still have eczema?",:pick=>:one
     a_1 "Yes"
     a_2 "No"
     a_3 "Don't Know"
     dependency :rule => "A"
     condition_A :q_essai_hp4, "==", :a_1

   q_essai_hp5a "Do you still have a food allergy?",:pick=>:one
     a_1 "Yes"
     a_2 "No"
     a_3 "Don't Know"
     dependency :rule => "A"
     condition_A :q_essai_hp5, "==", :a_1

  label "<strong>QUESTIONS ON MEDICATION YOU HAVE TAKEN IN THE PAST 30 DAYS</strong>"

    q_essai_27 "In the past 30 days, how often did you take Acetaminophen (or Paracetamol®, Panadol®, Percogesic®, Sedalmex®, Tylenol®, Vanquish®) for any reason? Please check appropriate box whether you take brand name or generic equivalent of all the medications listed.",:pick=>:one
    a_1 "less than once a month"
    a_2 "about once a month"
    a_3 "about once a week"
    a_3 "several times a week"
    a_3 "daily"

    q_essai_28 "In the past 30 days, how often did you take one of the following painkillers for any reason (for example Advil®, Arthrotec®, Aspirin®, Diclofenac®, Durogesic patch®, Feldene®, Flector®, Morphine drops, Motrin®, Ponstel®, Ryzolt®, Solaraze®, Tramadol®, Ultracet®, Ultram®, Voltaren®)? Please check appropriate box whether you take brand name or generic equivalent of all the medications listed.",:pick=>:one
    a_1 "less than once a month"
    a_2 "about once a month"
    a_3 "about once a week"
    a_4 "several times a week"
    a_5 "daily"

    q_essai_28a "If you have taken painkillers, which ones ?"
      a :text
    q_essai_29 "Have you taken antacids in the past 30 days (for example. Amphojel®, Alternagel®, Gaviscon®, Maalox®, Mylanta®, Riopan®, Rolaids®)? Please check appropriate box whether you take brand name or generic equivalent of all the medications listed.",:pick=>:one
      a_1 "yes"
      a_2 "no"
      a_3 "unsure (please discuss it with your physician)"

      q_essai_29a "which tablets did you take?"
        a :text
       dependency :rule => "A or B"
       condition_A :q_essai_29, "==", :a_1
       condition_B :q_essai_29, "==", :a_3
    q_essais_30 "Have you taken any of the following medication in the past 30 days: Axid® (nizatidine), Carafate® (sucralfate), Pepcid® (famotidine), Tagamet® (cimetidine), Zantac® (ranitidine)? Please check appropriate box whether you take brand name or generic equivalent of all the medications listed. "
      a_1 "yes"
      a_2 "no"
      a_3 "unsure (please discuss it with your physician)"

    q_essais_31 "Have you taken any of the following medication in the past 30 days: Aciphex® (rabeprazole), Kapidex® (dexlansoprazole), Nexium® (esomeprazole), Protonix® (pantoprazole), Prevacid® (lansoprazole), Prilosec OTC®, or Zegerid® (omeprazole/sodium bicarbonate)? Please check appropriate box whether you take brand name or generic equivalent of all the medications listed."
      a_1 "yes"
      a_2 "no"
      a_3 "unsure (please discuss it with your physician)"

    grid_essais_32 "Did you take any of the following drugs for any reason in the past 30 days? Please check appropriate box whether you take brand name or generic equivalent of all the medications listed." do 
      a_1 "yes"
      a_2 "no"
      a_3 "unsure (please discuss it with your physician)"

      q_essais_32a "Corticosteroid tablets (e.g. Prednisolone, Budesonide)",:pick=>:one
      q_essais_32b "Claritin®, Zyrtec® or another antihistaminic tablet",:pick=>:one
      q_essais_32c "Montelukast (Singulair® tablets) or Zafirlukast (Accolate®)",:pick=>:one
      q_essais_32d "Cromoglycate tablets (Gastrocrom®)",:pick=>:one

    end
    label "<strong>INHALERS </strong>(These inhalers are used by patients with asthma)"
   grid_essai_33 "Did you take any of the following inhalers in the past 30 days? Please check appropriate box whether you take brand name or generic equivalent of all the medications listed." do 
     a_1 "yes"
     a_2 "no"
     a_3 "don't know"

     q_essai_33a "Generic albuterol, Proventil®, Ventolin®, Pro-Air®, Maxair Autohaler®, Xopenex HFA®, Alupent®, Combivent® (Short acting bronchodilator)",:pick=>:one
     q_essai_33b "Aerobid®, Azmacort®, QVAR40®, Asmanex Twisthaler®, Flovent®, Pulmicort®",:pick=>:one
     q_essai_33c "Serevent Diskus® or Foradil Aerolizer®",:pick=>:one
     q_essai_33d "Advair® or Symbicort®",:pick=>:one
   end

   label "<strong> INJECTIONS</strong>"

   q_essai_34 "Did you get an injection with steroids (e.g. cortisone) in the past 30 days?",:pick=>:one
     a_1 "yes"
     a_2 "no"
     a_3 "don't know"
  end
end
