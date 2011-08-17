survey "Orientation Screener for Staff",:irb_number=>"STU00017350"  do
  section "PRIME MD/MINI" do
    label "I am now going to ask you a series of questions, and I’d like you to respond ‘Yes’ or ‘No’ to each of them. In this interview, 
    we ask the exact same questions to all participants in the study, so please note that 
    some of the questions will apply to you and others may not. Please answer each of the questions to the 
    best of your ability. I will read the questions exactly as they are written, but if you need any clarification 
    on them, please let me know. Do you have any questions before we get started?"
    
    label "<b><u>PRIME-MD: EATING MODULE</u></b>"
    
    q_1_eat_often "Do you <b>OFTEN</b> eat, within any 2-­‐hour period, what most people would regard as an unusually large amount of food?", 
    :help_text => "<i>If yes, ask for an example and if this is typical behavior.</i>", :pick => :one
    a_yes "Yes"
    a_no "No"
    
    q_2_can_control_eating "When you eat this way, do you often feel that you can’t control <u>what</u> or <u>how much</u> you eat?<br> 
    <i>If necessary, ask if they feel <u>compelled</u> to keep eating, if they feel like they <u>can’t stop</u>, or if they 
    feel like they <u>need</u> to or <u>have to</u> eat an unusually large amount of food.</i>", :pick => :one
    a_yes "Yes"
    a_no "No"
    dependency :rule => "A"
    condition_A :q_1_eat_often, "==", :a_yes
    
    q_3_often_cannot_control_eating "Has this been as often, on average, as twice a week for the last 3 months?", :pick => :one
    a_yes "Yes"
    a_no "No"
    dependency :rule => "A"
    condition_A :q_2_can_control_eating, "==", :a_yes
    
    q_4_makes_vomit "Do you often make yourself vomit, or take more than twice the recommended dosage of laxatives, 
    to avoid gaining weight after eating this way?", :pick => :one
    a_yes "Yes"
    a_no "No"
    dependency :rule => "A"
    condition_A :q_3_often_cannot_control_eating, "==", :a_yes
    
    q_5_how_often_makes_vomit "Has this been as often, on average, as twice a week for the last 3 months?", :pick => :one
    a_yes "YES - BULIMIA NERVOSA, PURGING TYPE"
    a_no "NO"
    dependency :rule => "A"
    condition_A :q_4_makes_vomit, "==", :a_yes
    
    q_6_how_often_fast "Do you often fast-­‐not eat anything at all for at least 24 hours-­‐or exercise for more than an hour
    specifically in order to avoid gaining weight after eating this way?", :pick => :one
    a_yes "YES"
    a_no "NO - BINGE EATING DISORDER"
    dependency :rule => "A or B"
    condition_A :q_4_makes_vomit, "==", :a_no
    condition_B :q_5_how_often_makes_vomit, "==", :a_no
    
    q_7_how_often_fast "Has this been as often, on average, as twice a week for the last 3 months?", :pick => :one
    a_yes "YES - BULIMIA NERVOSA, NONPURGING TYPE"
    a_no "NO - BINGE EATING DISORDER"
    dependency :rule => "A"
    condition_A :q_6_how_often_fast, "==", :a_yes
    
    label "<b><u>M.I.N.I: ALCOHOL and SUBSTANCE ABUSE/DEPENDENCE</u></b>"
    dependency :rule => "A or B or C or D or E or F or G"
    condition_A :q_1_eat_often, "==", :a_no
    condition_B :q_2_can_control_eating, "==", :a_no
    condition_C :q_3_often_cannot_control_eating, "==", :a_no
    condition_D :q_5_how_often_makes_vomit, "==", :a_yes
    condition_E :q_6_how_often_fast, "==", :a_no
    condition_F :q_7_how_often_fast, "==", :a_yes
    condition_G :q_7_how_often_fast, "==", :a_no
    
    q_8_had_drinks_within_three_hour_period "In the past 12 months, have you had 3 or more alcoholic drinks within a 3 hour period on 3 or 
    more occasions?", :pick => :one
    a_yes "Yes"
    a_no "No"
    dependency :rule => "A or B or C or D or E or F or G"
    condition_A :q_1_eat_often, "==", :a_no
    condition_B :q_2_can_control_eating, "==", :a_no
    condition_C :q_3_often_cannot_control_eating, "==", :a_no
    condition_D :q_5_how_often_makes_vomit, "==", :a_yes
    condition_E :q_6_how_often_fast, "==", :a_no
    condition_F :q_7_how_often_fast, "==", :a_yes
    condition_G :q_7_how_often_fast, "==", :a_no
    
    q_9 "In the past 12 months:", :pick => :any
    dependency :rule => "A"
    condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_yes
    a_1 "Have you been intoxicated, high, or hungover more than once when you had other responsibilities at school, at work, or at home? Did this cause 
     any problems? ", :help_text => "Select only if this caused problems."
    a_2  "In the past 12 months: Were you intoxicated in any situation where you were physically at risk, 
      for example, driving a car, riding a motorbike, using machinery, boating, etc?"
    a_3 "In the past 12 months: Did you have any legal problems because of your drinking, for example, an arrest or disorderly conduct?"
    a_4 "In the past 12 months: Did you continue to drink even though your drinking caused problems with your family or other people?"

    q_is_grid_9_has_yes_answers "Are 1 or more answers above coded yes?", :pick => :one
    dependency :rule => "A"
    condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_yes
    a_no "NO"
    a_yes "YES - CURRENT ALCOHOL ABUSE"

     q_10 "In the past 12 months:", :pick => :any
     dependency :rule => "A"
     condition_A :q_is_grid_9_has_yes_answers, "==", :a_yes
     a_1 "Did you need to drink more in order to get the same effect that you got when you first started drinking?"
     a_2 "When you cut down on drinking did your hands shake, did you sweat or feel agitated? Did you drink to avoid 
     these symptoms or to avoid being hungover, for example, “the shakes”, sweating or agitation? Select, if yes to either"
     a_3 "During the times when you drank alcohol, did you end up drinking more than you planned when you started?"
     a_4 "Have you tried to reduce or stop drinking alcohol but failed?"
     a_5 "On the days that you drank, did you spend substantial time in obtaining alcohol, drinking, or in recovery from the effects of alcohol?"
     a_6 "Did you spend less time working, enjoying hobbies, or being with others because of your drinking?"
     a_7 "Have you continued to drink even though you knew that the drinking caused you health or mental problems?"
       
    
    q_is_grid_10_has_three_yes_answers "Are 3 or more answers above coded yes?", :pick => :one
    dependency :rule => "A"
    condition_A :q_is_grid_9_has_yes_answers, "==", :a_yes
    a_no "NO"
    a_yes "YES - CURRENT ALCOHOL DEPENDENCE"    

     label "IN THE PAST 12 MONTHS, did you take any of these drugs more than once to get high, to feel better, or to change your mood?" 
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no      
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes
     
     q_11_a "Stimulants (i.e. speed, amphetamines, Ritalin, Dexedrine)", :pick => :one
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no      
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes     
     a_yes "Yes"
     a_no "No"
     
     group "Additional information on Stimulants" do
       dependency :rule => "A"
       condition_A :q_11_a, "==", :a_yes
       q_prescribed_by_doctor "Prescribed by a doctor?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_higher_than_recommended_dose "Taking more than the recommended dose?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_reason "Reason"
       a :text
       q_duration "Duration of use"
       a :string
       q_frequency "Frequency of use"
       a :string
       q_dosage "Dosage"
       a :string
     end
     
     q_11_b "Cocaine (snorting, IV, free base, crack)", :pick => :one
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no       
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes     
     a_yes "Yes"
     a_no "No"

     group "Additional information on Cocaine" do
       dependency :rule => "B"
       condition_B :q_11_b, "==", :a_yes
       q_prescribed_by_doctor "Prescribed by a doctor?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_higher_than_recommended_dose "Taking more than the recommended dose?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_reason "Reason"
       a :text
       q_duration "Duration of use"
       a :string
       q_frequency "Frequency of use"
       a :string
       q_dosage "Dosage"
       a :string
     end

     q_11_c "Narcotics (heroin, morphine, opium, methadone, codeine, Demerol, Vicodin)", :pick => :one
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no    
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes     
     a_yes "Yes"
     a_no "No"

     group "Additional information on Narcotics" do
       dependency :rule => "C"
       condition_C :q_11_c, "==", :a_yes
       q_prescribed_by_doctor "Prescribed by a doctor?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_higher_than_recommended_dose "Taking more than the recommended dose?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_reason "Reason"
       a :text
       q_duration "Duration of use"
       a :string
       q_frequency "Frequency of use"
       a :string
       q_dosage "Dosage"
       a :string
     end
     
     q_11_d "Hallucinogens (ecstacy, LSD, acid, mescaline, peyote, PCP, mushrooms, MDMA, Angel Dust, psilocybin)", :pick => :one
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no     
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes     
     a_yes "Yes"
     a_no "No"
          
     group "Additional information on Hallucinogens" do
       dependency :rule => "D"
       condition_D :q_11_d, "==", :a_yes
       q_prescribed_by_doctor "Prescribed by a doctor?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_higher_than_recommended_dose "Taking more than the recommended dose?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_reason "Reason"
       a :text
       q_duration "Duration of use"
       a :string
       q_frequency "Frequency of use"
       a :string
       q_dosage "Dosage"
       a :string
     end          
          
     q_11_e "Inhalants (glue, laughing gas, amyl or butyl nitrate)", :pick => :one
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes     
     a_yes "Yes"
     a_no "No"
        
     group "Additional information on Inhalants" do
       dependency :rule => "E"
       condition_E :q_11_e, "==", :a_yes
       q_prescribed_by_doctor "Prescribed by a doctor?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_higher_than_recommended_dose "Taking more than the recommended dose?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_reason "Reason"
       a :text
       q_duration "Duration of use"
       a :string
       q_frequency "Frequency of use"
       a :string
       q_dosage "Dosage"
       a :string
     end        
          
     q_11_f "Marijuana (hashish, THC, pot, weed, grass, reefer)", :pick => :one
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes     
     a_yes "Yes"
     a_no "No"     

     group "Additional information on Marijuana" do
       dependency :rule => "F"
       condition_F :q_11_f, "==", :a_yes
       q_prescribed_by_doctor "Prescribed by a doctor?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_higher_than_recommended_dose "Taking more than the recommended dose?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_reason "Reason"
       a :text
       q_duration "Duration of use"
       a :string
       q_frequency "Frequency of use"
       a :string
       q_dosage "Dosage"
       a :string
     end
     
     q_11_g "Tranquilizers (Quaaludes, Valium, Xanax, Ativan, barbiturates, Halcion, Seconal)", :pick => :one
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes
     a_yes "Yes"
     a_no "No"     

     group "Additional information on Tranquilizers" do
       dependency :rule => "G"
       condition_G :q_11_g, "==", :a_yes
       q_prescribed_by_doctor "Prescribed by a doctor?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_higher_than_recommended_dose "Taking more than the recommended dose?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_reason "Reason"
       a :text
       q_duration "Duration of use"
       a :string
       q_frequency "Frequency of use"
       a :string
       q_dosage "Dosage"
       a :string
     end
     
     q_11_h "Miscellaneous (steroids, nonprescription sleep or diet pills, prescription drugs not prescribed to you)", :pick => :one
     dependency :rule => "A or B or C or D"
     condition_A :q_8_had_drinks_within_three_hour_period, "==", :a_no
     condition_B :q_is_grid_9_has_yes_answers, "==", :a_no
     condition_C :q_is_grid_10_has_three_yes_answers, "==", :a_no
     condition_D :q_is_grid_10_has_three_yes_answers, "==", :a_yes
     a_yes "Yes"
     a_no "No"
     
     group "Additional information on Miscellaneous" do
       dependency :rule => "H"
       condition_H :q_11_h, "==", :a_yes
       q_prescribed_by_doctor "Prescribed by a doctor?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_higher_than_recommended_dose "Taking more than the recommended dose?", :pick => :one
       a_yes "Yes"
       a_no "No"
       q_reason "Reason"
       a :text
       q_duration "Duration of use"
       a :string
       q_frequency "Frequency of use"
       a :string
       q_dosage "Dosage"
       a :string
     end     

     q_11a_which_drug_was_used_the_most "Of these, which drug did you use the most?"
     a :string
     dependency :rule => "A or B or C or D or E or F or G or H"
     condition_A :q_11_a, "==", :a_yes
     condition_B :q_11_b, "==", :a_yes
     condition_C :q_11_c, "==", :a_yes
     condition_D :q_11_d, "==", :a_yes
     condition_E :q_11_e, "==", :a_yes
     condition_F :q_11_f, "==", :a_yes
     condition_G :q_11_g, "==", :a_yes
     condition_H :q_11_h, "==", :a_yes
     
     q_11b_which_drug_was_used_second_most "Of these, which drug did you use the second most?"
     a :string
     dependency :rule => "A or B or C or D or E or F or G or H"
     condition_A :q_11_a, "==", :a_yes
     condition_B :q_11_b, "==", :a_yes
     condition_C :q_11_c, "==", :a_yes
     condition_D :q_11_d, "==", :a_yes
     condition_E :q_11_e, "==", :a_yes
     condition_F :q_11_f, "==", :a_yes
     condition_G :q_11_g, "==", :a_yes
     condition_H :q_11_h, "==", :a_yes     
     
     q_12_most_used_drug "Considering your use of the most used drug, in the past 12 months:", :pick => :any
     dependency :rule => "A or B or C or D or E or F or G or H"
      condition_A :q_11_a, "==", :a_yes
      condition_B :q_11_b, "==", :a_yes
      condition_C :q_11_c, "==", :a_yes
      condition_D :q_11_d, "==", :a_yes
      condition_E :q_11_e, "==", :a_yes
      condition_F :q_11_f, "==", :a_yes
      condition_G :q_11_g, "==", :a_yes
      condition_H :q_11_h, "==", :a_yes
     a_1 "Have you been intoxicated, high, or hungover from (name of drug/drug class selected) more than once, when you had 
       other responsibilities at school, at work, or at home?"
     a_2 "Have you been high or intoxicated from (name of drug/drug class selected) in any situation where you were physically at risk (for 
         example, driving a car, riding a motorbike, using machinery, boating, etc)?"
     a_3 "Did you have any legal problems because of your drug use, for example, an arrest or disorderly conduct?"
     a_4 "Did you continue to use (name of drug/drug class selected), even though it caused problems with your family or other people?"
     a_5 "None of these"


     q_12_most_second_used_drug "Considering your use of the 2nd most used drug, in the past 12 months:", :pick => :any
     dependency :rule => "A or B or C or D or E or F or G or H"
      condition_A :q_11_a, "==", :a_yes
      condition_B :q_11_b, "==", :a_yes
      condition_C :q_11_c, "==", :a_yes
      condition_D :q_11_d, "==", :a_yes
      condition_E :q_11_e, "==", :a_yes
      condition_F :q_11_f, "==", :a_yes
      condition_G :q_11_g, "==", :a_yes
      condition_H :q_11_h, "==", :a_yes
     a_1 "Have you been intoxicated, high, or hungover from (name of drug/drug class selected) more than once, when you had 
       other responsibilities at school, at work, or at home?"
     a_2 "Have you been high or intoxicated from (name of drug/drug class selected) in any situation where you were physically at risk (for 
         example, driving a car, riding a motorbike, using machinery, boating, etc)?"
     a_3 "Did you have any legal problems because of your drug use, for example, an arrest or disorderly conduct?"
     a_4 "Did you continue to use (name of drug/drug class selected), even though it caused problems with your family or other people?"
     a_5 "None of these"

     label "<b>CURRENT DRUG ABUSE</b>" 
     dependency :rule => "A or B or C or D or E or F or G or H"
     condition_A :q_12_most_used_drug, "==", :a_1
     condition_B :q_12_most_used_drug, "==", :a_2
     condition_C :q_12_most_used_drug, "==", :a_3
     condition_D :q_12_most_used_drug, "==", :a_4
     condition_E :q_12_most_second_used_drug, "==", :a_1
     condition_F :q_12_most_second_used_drug, "==", :a_2
     condition_G :q_12_most_second_used_drug, "==", :a_3
     condition_H :q_12_most_second_used_drug, "==", :a_4                              
     
     q_13_most_used_drug "Considering your use of the most used drug, in the past 12 months:", :pick => :any
     dependency :rule => "A or B or C or D or E or F or G or H"
     condition_A :q_12_most_used_drug, "==", :a_1
     condition_B :q_12_most_used_drug, "==", :a_2
     condition_C :q_12_most_used_drug, "==", :a_3
     condition_D :q_12_most_used_drug, "==", :a_4
     condition_E :q_12_most_second_used_drug, "==", :a_1
     condition_F :q_12_most_second_used_drug, "==", :a_2
     condition_G :q_12_most_second_used_drug, "==", :a_3
     condition_H :q_12_most_second_used_drug, "==", :a_4
     a_1 "Have you found that you needed to use more (name of drug/drug selected) to get the same effect that you did when you first started taking it?"
     a_2 "  When you reduced or stopped using (name of drug/drug class selected), did you have withdrawal symptoms (aches, shaking, fever, 
     weakness, diarrhea, nausea, sweating, heart pounding, difficulties sleeping, or feel agitated, anxious, irritable, or depressed)? Did you 
     use any drug(s) to keep yourself from getting sick (withdrawal symptoms) or so that you would feel better?"
     a_3 "  Have you often found that when you used (name of drug/drug class selected), you ended up taking more than you thought you would?"
     a_4 "Have you tried to reduce or stop taking (name of drug/drug class selected) but failed?"
     a_5 "On the days that you used (name of drug/drug class selected), did you spend substantial time (>2 hours), obtaining, using, or 
     in recovery from the drug, or thinking about the drug?"
     a_6 "Did you spend less time, working, enjoying hobbies, or being with family or friends because of your drug use?"
     a_7 "Have you continued to use (name of drug/drug class selected), even though it caused you health or mental problems?"
     
     q_13_second_most_used_drug "Considering your use of the 2nd most used drug, in the past 12 months:", :pick => :any
     dependency :rule => "A or B or C or D or E or F or G or H"
     condition_A :q_12_most_used_drug, "==", :a_1
     condition_B :q_12_most_used_drug, "==", :a_2
     condition_C :q_12_most_used_drug, "==", :a_3
     condition_D :q_12_most_used_drug, "==", :a_4
     condition_E :q_12_most_second_used_drug, "==", :a_1
     condition_F :q_12_most_second_used_drug, "==", :a_2
     condition_G :q_12_most_second_used_drug, "==", :a_3
     condition_H :q_12_most_second_used_drug, "==", :a_4
     a_1 "Have you found that you needed to use more (name of drug/drug selected) to get the same effect that you did when you first started taking it?"
     a_2 "  When you reduced or stopped using (name of drug/drug class selected), did you have withdrawal symptoms (aches, shaking, fever, 
     weakness, diarrhea, nausea, sweating, heart pounding, difficulties sleeping, or feel agitated, anxious, irritable, or depressed)? Did you 
     use any drug(s) to keep yourself from getting sick (withdrawal symptoms) or so that you would feel better?"
     a_3 "  Have you often found that when you used (name of drug/drug class selected), you ended up taking more than you thought you would?"
     a_4 "Have you tried to reduce or stop taking (name of drug/drug class selected) but failed?"
     a_5 "On the days that you used (name of drug/drug class selected), did you spend substantial time (>2 hours), obtaining, using, or 
     in recovery from the drug, or thinking about the drug?"
     a_6 "Did you spend less time, working, enjoying hobbies, or being with family or friends because of your drug use?"
     a_7 "Have you continued to use (name of drug/drug class selected), even though it caused you health or mental problems?"
     
     q_14_any_of_the_3_answers "Are 3 or more of the above answers coded yes?", :pick => :one
     dependency :rule => "A or B or C or D or E or F or G or H"
     condition_A :q_12_most_used_drug, "==", :a_1
     condition_B :q_12_most_used_drug, "==", :a_2
     condition_C :q_12_most_used_drug, "==", :a_3
     condition_D :q_12_most_used_drug, "==", :a_4
     condition_E :q_12_most_second_used_drug, "==", :a_1
     condition_F :q_12_most_second_used_drug, "==", :a_2
     condition_G :q_12_most_second_used_drug, "==", :a_3
     condition_H :q_12_most_second_used_drug, "==", :a_4
     a_yes "Yes"
     a_no "No"
     
     label "<b>CURRENT DRUG DEPENDENCE</b>"
     dependency :rule => "A"
     condition_A :q_14_any_of_the_3_answers, "==", :a_yes      
     
     # label "<b>CURRENT DRUG DEPENDENCE</b>"
     #  dependency :rule => "(C and D) or (E and F) or (G and H) or (I and G)"
     #  condition_C :q_13_most_used_drug, "count>=0"
     #  condition_D :q_13_second_most_used_drug, "count>=3"
     #  condition_E :q_13_most_used_drug, "count>=3"
     #  condition_F :q_13_second_most_used_drug, "count>=0"
     #  condition_G :q_13_most_used_drug, "count>=1"
     #  condition_H :q_13_second_most_used_drug, "count>=2"
     #  condition_I :q_13_most_used_drug, "count>=2"
     #  condition_G :q_13_second_most_used_drug, "count>=1"
       
     label "<b>MINI COMPLETE (Have Patient Complete PHQ-9 and AS)</b>"  
     dependency :rule => "(A and B and C and D and E and F and G and H) or (I and J) or M or N"
     condition_A :q_11_a, "==", :a_no
     condition_B :q_11_b, "==", :a_no
     condition_C :q_11_c, "==", :a_no
     condition_D :q_11_d, "==", :a_no
     condition_E :q_11_e, "==", :a_no
     condition_F :q_11_f, "==", :a_no
     condition_G :q_11_g, "==", :a_no
     condition_H :q_11_h, "==", :a_no       
     condition_I :q_12_most_used_drug, "==", :a_5
     condition_J :q_12_most_second_used_drug, "==", :a_5     
     condition_M :q_14_any_of_the_3_answers, "==", :a_yes
     condition_N :q_14_any_of_the_3_answers, "==", :a_no
  end
  section "Breath Holding Test" do
    label "Explain to participant that you will be asking him/her to take a breath and then hold it for as long as 
    possible. Inform the participant that you will be timing how long she/he can hold his/her breath. 
    If participant asks why you are requesting that he/she does this task, tell him/her that we are interested 
    in seeing if there is a relationship between how long he/she can hold his/her breath and some of the 
    other questionnairs/measures in the study. 
    Establish a \"signal\" (i.e., participant holds a thumb up) that the participant will give you when he/she 
    starts holding his/her breath and also when he/she stops holding his/her breath. Tell the participant 
    you will begin timing when he/she gives the signal that breath holding has begun and you will stop 
    timing when he/she gives the signal that breath holding has stopped. 
    If participant would like to know how long he/she held his/her breath, you can feel free to tell him/her."
    
    group "Breath holding time:", :display_type => :inline do
       q_minutes "Minute(s)", :pick => :one, :display_type => :dropdown
       a "00"
       a "01"
       a "02"
       a "03"
       a "04"
       a "05"
       a "06"
       a "07"
       a "08"
       a "09"
       a "10"
       a "11"
       a "12"
       a "13"
       a "14"
       a "15"
       a "16"
       a "17"
       a "18"
       a "19"
       a "20"
       a "21"
       a "22"
       a "23"
       a "24"
       a "25"
       a "26"
       a "27"
       a "28"
       a "29"
       a "30"
       a "31"
       a "32"
       a "33"
       a "34"
       a "35"
       a "36"
       a "37"
       a "38"
       a "39"
       a "40"
       a "41"
       a "42"
       a "43"
       a "44"
       a "45"
       a "46"
       a "47"
       a "48"
       a "49"
       a "50"
       a "51"
       a "52"
       a "53"
       a "54"
       a "55"
       a "56"
       a "57"
       a "58"
       a "59"

       q_seconds "Second(s)", :pick => :one, :display_type => :dropdown
       a "00"
       a "01"
       a "02"
       a "03"
       a "04"
       a "05"
       a "06"
       a "07"
       a "08"
       a "09"
       a "10"
       a "11"
       a "12"
       a "13"
       a "14"
       a "15"
       a "16"
       a "17"
       a "18"
       a "19"
       a "20"
       a "21"
       a "22"
       a "23"
       a "24"
       a "25"
       a "26"
       a "27"
       a "28"
       a "29"
       a "30"
       a "31"
       a "32"
       a "33"
       a "34"
       a "35"
       a "36"
       a "37"
       a "38"
       a "39"
       a "40"
       a "41"
       a "42"
       a "43"
       a "44"
       a "45"
       a "46"
       a "47"
       a "48"
       a "49"
       a "50"
       a "51"
       a "52"
       a "53"
       a "54"
       a "55"
       a "56"
       a "57"
       a "58"
       a "59"
       
       q_milliseconds "Millisecond(s)", :pick => :one, :display_type => :dropdown
       a "00"
       a "01"
       a "02"
       a "03"
       a "04"
       a "05"
       a "06"
       a "07"
       a "08"
       a "09"
       a "10"
       a "11"
       a "12"
       a "13"
       a "14"
       a "15"
       a "16"
       a "17"
       a "18"
       a "19"
       a "20"
       a "21"
       a "22"
       a "23"
       a "24"
       a "25"
       a "26"
       a "27"
       a "28"
       a "29"
       a "30"
       a "31"
       a "32"
       a "33"
       a "34"
       a "35"
       a "36"
       a "37"
       a "38"
       a "39"
       a "40"
       a "41"
       a "42"
       a "43"
       a "44"
       a "45"
       a "46"
       a "47"
       a "48"
       a "49"
       a "50"
       a "51"
       a "52"
       a "53"
       a "54"
       a "55"
       a "56"
       a "57"
       a "58"
       a "59"
     end
  end
  section "Physical Measures" do
    q_height "Height (inches):"
    a :string
    
    q_weight "Weight (pounds):"
    a :string
    
    q_bmi "BMI: (29.5 - 40.4)", 
    :help_text =>"BMI = lbs*703/(inches*inches)"
    a "BMI", :float    
    
    label "<a href=\"http://www.nhlbisupport.com/bmi/\" target=\"_blank\">BMI Calculator</a>" 
    
    q_waist "Waist Circumference",
    :help_text => "(cm)"
    a :string
    
    q_blood_pressure "Blood Pressure",
    :help_text => "systolic/diastolic (mmHg)"
    a :string   
    
    label "<b>ELIGIBLE</b>"
    dependency :rule => "A and B"
    condition_A :q_bmi, ">=", {:float_value => "29.5"} 
    condition_B :q_bmi, "<=", {:float_value => "40.4"}
    
    label "<b>NOT ELIGIBLE</b>" 
    dependency :rule => "A or B"
    condition_A :q_bmi, "<", {:float_value => "29.5"} 
    condition_B :q_bmi, ">", {:float_value => "40.4"}       
  end   
end
