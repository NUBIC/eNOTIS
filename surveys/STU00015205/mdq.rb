survey "MAYO DYSPHAGIA QUESTIONNAIRE",:irb_number=>'STU00015205',:is_public=>true do 
  section "main" do
   q_1 "When in your life did you first notice trouble swallowing?",:pick=>:one

     a_1 "Never had trouble swallowing"
     a_2 "Less than 1 month ago "
     a_3 "to 3 months ago"
     a_4 "to 11 months ago"
     a_5 "1 to 5 years ago" 
     a_6 "More than 5 years ago"

   q_2 "In the past 30 days, have you had trouble swallowing, not associated with other cold symptoms (such as strep throat or mono)?",:pick=>:one
     a_1 "Yes"
     a_2 "No"
     dependency :rule => "A or B or C or D or E"
     condition_A :q_1, "==", :a_2
     condition_B :q_1, "==", :a_3
     condition_C :q_1, "==", :a_4
     condition_D :q_1, "==", :a_5
     condition_E :q_1, "==", :a_6
 
   q_3 "In the past 30 days, has your swallowing trouble gotten better, remained unchanged, or gotten worse?",:pick=>:one
     a_1 "Better"
     a_2 "Unchanged"
     a_3 "Worse"
     dependency :rule => "A"
     condition_A :q_2, "==", :a_1

   q_3a "If your swallowing trouble has changed in the past 30 days, how much has it changed?",:pick=>:one
     a_1 "Changed hardly at all"
     a_2 "Change a little"
     a_3 "Moderately changed"
     a_4 "Changed a good bit"
     a_5 "Changed very much"
     a_6 "Change a great deal"
     dependency :rule => "A or B"
     condition_A :q_3, "==", :a_1
     condition_B :q_3, "==", :a_3

   q_4 "How would you rate the severity of your trouble swallowing over the past 30 days?",:pick=>:one
     a_1 "Doesn’t bother me at all"
     a_2 "Mild — can be ignored if I don’t think about it"
     a_3 "Moderate — cannot be ignored, but does not affect my lifestyle"
     a_4 "Severe — affects my lifestyle"
     a_5 "Very severe — markedly affects my lifestyle"
     a_6 "I don’t know/remember"
     dependency :rule => "A"
     condition_A :q_2, "==", :a_1

   q_5 "In the past 30 days, on a scale of 0 to 10, how would you rate the severity of your trouble swallowing with 0 being 'Not at all severe' and 10 being 'Very severe'?",:pick=>:one
     a_1 "0"
     a_2 "1"
     a_3 "2"
     a_4 "3"
     a_5 "4"
     a_6 "5"
     a_7 "6"
     a_8 "7"
     a_9 "8"
     a_10 "9"
     a_11 "10"
     dependency :rule => "A"
     condition_A :q_2, "==", :a_1

   q_6 "How do you rate your swallowing problem today?",:pick=>:one
     a_1 "0"
     a_2 "1"
     a_3 "2"
     a_4 "3"
     a_5 "4"
     a_6 "5"
     a_7 "6"
     dependency :rule => "A"
     condition_A :q_2, "==", :a_1

  q_7 "How often have you had difficulty swallowing in the past 30 days?",:pick=>:one
     a_1 "None"
     a_2 "Less than once a week"
     a_3 "Once a week"
     a_4 "Several times a week"
     a_5 "Daily"
     a_6 "With every meal"
     a_7 "With each swallow"
     a_8 "Unable"
     dependency :rule => "A"
     condition_A :q_2, "==", :a_1

  q_8 "Do you have problems swallowing liquids?",:pick=>:one
    a_1 "Yes"
    a_1 "No"
    dependency :rule => "A"
    condition_A :q_2, "==", :a_1

  q_8a "Is it with:",:pick=>:one
    a_1 "Cold liquids only"
    a_2 "Warm liquids only"
    a_3 "Both cold and warm liquids"
    dependency :rule => "A"
    condition_A :q_8, "==", :a_1


  q_9 "Do you have problems swallowing solid foods?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    dependency :rule => "A"
    condition_A :q_2, "==", :a_1

  q_9a "Do you have problems swallowing liquids after solid food is stuck?"
    a_1 "Yes"
    a_1 "No"
    dependency :rule => "A"
    condition_A :q_9, "==", :a_1


  grid_10 "In the past 30 days, have you avoided any of the following types of foods to avoid food getting stuck?" do 
    dependency :rule => "A"
    condition_A :q_2, "==", :a_1

    a_1 "Yes"
    a_2 "No"

    q_10a "Oatmeal (or other foods, like grits, cream of wheat, rice)",:pick=>:one
    q_10b "Banana (or other foods, like pudding, jello)",:pick=>:one
    q_10c "Apple (or other foods with fiber, such as celery)",:pick=>:one
    q_10d "Ground meat (like hamburger or ground turkey)",:pick=>:one
    q_10e "Bread (or other foods, like cake, doughnuts, muffins)",:pick=>:one
    q_10f "Meat (fibrous meats, like steak or chicken)",:pick=>:one
  end
    

  grid_11 "In the past 30 days, have you had trouble swallowing any of these foods or other foods like them?" do 
    dependency :rule => "A"
    condition_A :q_2, "==", :a_1

    a_1 "Yes"
    a_2 "No"

   
    q_11a "Oatmeal (or other foods, like grits, cream of wheat, rice)",:pick=>:one
    q_11b "Banana (or other foods, like pudding, jello)",:pick=>:one
    q_11c "Apple (or other foods with fiber, such as celery)",:pick=>:one
    q_11d "Ground meat (like hamburger or ground turkey)",:pick=>:one
    q_11e "Bread (or other foods, like cake, doughnuts, muffins)",:pick=>:one
    q_11f "Meat (fibrous meats, like steak or chicken)",:pick=>:one
  end

  q_12 "Do you modify your food (such as boil, use a blender, cut into small pieces, or dunk in liquid) to make it easier to swallow?",:pick=>:one
    a_1 "Yes"
    a_2 "Yes"
    dependency :rule => "A"
    condition_A :q_2, "==", :a_1

  q_12a "If yes, which of the following foods or foods like them do you modify?",:pick=>:any
    a_1 "Oatmeal (or other foods, like grits, cream of wheat, rice)"
    a_2 "Banana (or other foods, like pudding, jello)"
    a_3 "Apple (or other foods with fiber, such as celery)"
    a_4 "Ground meat (like hamburger or ground turkey)"
    a_5 "Bread (or other foods, like cake, doughnuts, muffins)"
    a_6 "Meat (fibrous meats, like steak or chicken)"
    dependency :rule => "A"
    condition_A :q_12, "==", :a_1


  q_13 "Compared to other people around you, in the past 30 days, at what pace do you chew during a meal?",:pick=>:one
    a_1 "At the same speed"
    a_2 "A little slower"
    a_3 "Much slower"
    dependency :rule => "A"
    condition_A :q_2, "==", :a_1

  q_14 "How many minutes does it take you to eat an average meal?",:pick=>:one
    a_1 "15 minutes"
    a_2 "16 to 30 minutes"
    a_3 "31 to 45 minutes"
    a_4 "46 to 60 minutes"
    a_5 "More than 60 minutes"
    a_6 "Can’t eat"
    dependency :rule => "A"
    condition_A :q_2, "==", :a_1

  q_15 "In the past 30 days, have you had pills stick in your swallowing tube?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    dependency :rule => "A"
    condition_A :q_2, "==", :a_1

  q_16 "In the past 30 days, have you had solid food (not medications) stick in your swallowing tube?",:pick=>:one
    a_1 "Yes"
    a_2 "No"

  q_16a "Was it stuck for: ",:pick=>:one
    a_1 "Less than 5 minutes"
    a_2 "5 minutes or more"
    dependency :rule => "A"
    condition_A :q_16, "==", :a_1

  q_17 "In the past 30 days, when swallowing:",:pick=>:any
    a_1 "It hurts all the way down"
    a_2 "It hurts when food gets stuck"
    a_3 "It doesn’t hurt at all"

  q_18 "In the past 30 days, have you experienced heartburn, a burning pain or discomfort behind the breast bone in the chest?",:pick=>:one
    a_1 "Yes"
    a_2 "No"

  q_18a "How often does this or did this heartburn occur?",:pick=>:one
    a_1 "Less than once a month" 
    a_2 "About once a month"
    a_3 "About once a week"
    a_4 "Several times a week"
    a_5 "Daily"
    dependency :rule => "A"
    condition_A :q_18, "==", :a_1

  q_18b "Is your heartburn better (eased) by taking antacids? (Examples: Amphojel, Alternagel, Gaviscon, Maalox, Mylanta, Riopan, Rolaids, Tums.)",:pick=>:one
    a_1 "I do not take antacids for heartburn"
    a_2 "Yes"
    a_3 "No"
    dependency :rule => "A"
    condition_A :q_18, "==", :a_1

  q_18c "In the past 30 days, has your heartburn awakened you at night?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    dependency :rule => "A"
    condition_A :q_18, "==", :a_1

  q_18d "In the past 30 days, has your heartburn often traveled up toward your neck?",:pick=>:one 
    a_1 "Yes"
    a_2 "No"
    dependency :rule => "A"
    condition_A :q_18, "==", :a_1

  q_19 "In the past 30 days, have you experienced acid regurgitation, a bitter or sour-tasting fluid coming up from the stomach into your mouth or throat?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
 
  q_19a "Do you experience acid regurgitation at least once a week?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    dependency :rule => "A"
    condition_A :q_19, "==", :a_1

  q_20 "Have you ever been diagnosed with seasonal or environmental (dogs, cats, cows, horses, weeds, mold, pollen) allergies?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    a_3 "Don't know/Not sure"

  q_21 "Have you ever been diagnosed with a food allergy?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    a_3 "Don't know/Not sure"

  q_22 "Have you ever been told by a doctor, nurse, or other health professional that you had asthma?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    a_3 "Don't know/Not sure"
    a_4 "Resfused"

  q_22a "Do you still have asthma?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    a_3 "Don't know/Not sure"
    a_4 "Resfused"
    dependency :rule => "A"
    condition_A :q_22, "==", :a_1

  q_23 "Have you taken antacids in the past 30 days? (Examples: Amphojel, Alternagel, Gaviscon, Maalox, Mylanta, Riopan, Rolaids, Tums used as an antacid.)",:pick=>:one
    a_1 "Yes"
    a_2 "No"

  q_24 "Have you taken any of the following medicines in the past 30 days: Axid (nizatidine), Carafate (sucralfate), Pepcid (famotidine), Tagamet (cimetidine), Zantac (ranitidine)?",:pick=>:one
    a_1 "Yes"
    a_2 "No"

  q_25 "Have you taken any of the following medicines in the past 30 days: Aciphex (rabeprazole), Nexium (esomeprazole), Protonix (pantoprazole), Prevacid (lansoprazole), Prilosec, Prilosec OTC, Zegerid (omeprazole), or Kapidex?",:pick=>:one
    a_1 "Yes"
    a_2 "No"

  q_26 "Have you had a surgical treatment or procedure where part of your stomach was wrapped around the end of your esophagus (Nissen or Belsey fundoplication)?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    a_3 "Unsure"

  q_26a "Was this done in the past 30 days?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    dependency :rule => "A"
    condition_A :q_26, "==", :a_1

  q_27 "Have you had part of your esophagus removed?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    a_3 "Unsure"

  q_27a "Was this done in the past 30 days?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    dependency :rule => "A"
    condition_A :q_27, "==", :a_1

  q_28 "Have you had dilation (stretching) of the esophagus?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    a_3 "Unsure"

  q_28a "Was this done in the past 30 days?",:pick=>:one
    a_1 "Yes"
    a_2 "No"
    dependency :rule => "A"
    condition_A :q_28, "==", :a_1
 end
end
