survey "BSI-18" ,:irb_number=>'STU00015205' ,:score_configurations_attributes=>[{:name=>'General Distress Scale',:algorithm=>'total_sum'},{:name=>'Somatization',:algorithm=>"partial_sum",:question_code=>"somatization"},{:name=>'Depression', :algorithm=>"partial_sum",:question_code=>"depression"},{:name=>'Anxiety', :algorithm=>"partial_sum",:question_code=>"anxiety"}]do 
  section "main" do

    label"Instructions: Below is a list of problems people sometimes have. Please read each one carefully, and blacken the circle that best describes HOW MUCH THAT PROBLEM HAS DISTRESSED OR BOTHERED YOU DURING THE PAST 7 DAYS INCLUDING TODAY."

    grid "HOW MUCH WERE YOU DISTRESSED BY" do

      a_1 "Not at all",:weight=>0
      a_2 "A little bit",:weight=>1
      a_3 "Moderately",:weight=>2
      a_4 "Quite a bit",:weight=>3
      a_5 "Extremely",:weight=>4

      q_bsi_1 "Faintness or dizziness",:pick=>:one,:score_code=>'somatization'
      q_bsi_2 "Feeling no interest in things",:pick=>:one,:score_code=>"depression"
      q_bsi_3 "Nervousness or shakiness inside",:pick=>:one,:score_code=>"anxiety"
      q_bsi_4 "Pains in heart or chest",:pick=>:one,:score_code=>'somatization'
      q_bsi_5 "Feeling lonely",:pick=>:one,:score_code=>"depression"
      q_bsi_6 "Feeling tense or keyed up",:pick=>:one,:score_code=>"anxiety"
      q_bsi_7 "Nausea or upset stomach",:pick=>:one,:score_code=>'somatization'
      q_bsi_8 "Feeling blue",:pick=>:one,:score_code=>"depression"
      q_bsi_9 "Suddenly scared for no reason",:pick=>:one,:score_code=>"anxiety"
      q_bsi_10 "Trouble getting your breath",:pick=>:one,:score_code=>'somatization'
      q_bsi_11 "Feelings of worthlessness",:pick=>:one,:score_code=>"depression"
      q_bsi_12 "Spells of terror or panic",:pick=>:one,:score_code=>"anxiety"
      q_bsi_13 "Numbness or tingling in parts of your body",:pick=>:one,:score_code=>'somatization'
      q_bsi_14 "Feeling hopeless about the future",:pick=>:one,:score_code=>"depression"
      q_bsi_15 "Feeling so restless you couldn't sit still",:pick=>:one,:score_code=>"anxiety"
      q_bsi_16 "Feeling weak in parts of your body",:pick=>:one,:score_code=>'somatization'
      q_bsi_17 "Thoughts of ending your life",:pick=>:one,:score_code=>"depression"
      q_bsi_18 "Feeling fearful",:pick=>:one,:score_code=>"anxiety"
    end
  end
end
