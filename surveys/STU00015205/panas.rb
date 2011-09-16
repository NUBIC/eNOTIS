survey "PANAS Questionnaire",:irb_number=>"STU00015205",:score_configurations_attributes=>[{:name=>"Positive Affect Score:",:algorithm=>'partial_sum',:question_code=>'pas'},{:name=>"Negative Affect Score",:algorithm=>'partial_sum',:question_code=>'nas'}],:is_public=>true  do 
  section "PANAS Questionnaire" do 

    grid "This scale consists of a number of words that describe different feelings and emotions. Read each item and then list the number from the scale below next to each word. <strong>Indicate to what extent you feel this way right now, that is, at the present moment OR indicate the extent you have felt this way over the past week (circle the instructions you followed when taking this measure)</strong>" do 

      a_1 "Very Slightly or Not at All",:weight=>1
      a_2 "A Little",:weight=>2
      a_3 "Moderately",:weight=>3
      a_4 "Quite a Bit",:weight=>4
      a_5 "Extremely",:weight=>5

      q_1 "Interested",:pick=>:one,:score_code=>"pas"
      q_2 "Distressed",:pick=>:one,:score_code=>"nas"
      q_3 "Excited",:pick=>:one,:score_code=>"pas"
      q_4 "Upset",:pick=>:one,:score_code=>"nas"
      q_5 "Strong",:pick=>:one,:score_code=>"pas"
      q_6 "Guilty",:pick=>:one,:score_code=>"nas"
      q_7 "Scared",:pick=>:one,:score_code=>"nas"
      q_8 "Hostile",:pick=>:one,:score_code=>"nas"
      q_9 "Enthusiastic",:pick=>:one,:score_code=>"pas"
      q_10 "Proud",:pick=>:one,:score_code=>"pas"
      q_11 "Irritable",:pick=>:one,:score_code=>"nas"
      q_12 "Alert",:pick=>:one,:score_code=>"pas"
      q_13 "Ashamed",:pick=>:one,:score_code=>"nas"
      q_14 "Inspired",:pick=>:one,:score_code=>"pas"
      q_15 "Nervous",:pick=>:one,:score_code=>"nas"
      q_16 "Determined",:pick=>:one,:score_code=>"pas"
      q_17 "Attentive",:pick=>:one,:score_code=>"pas"
      q_18 "Jittery",:pick=>:one,:score_code=>"nas"
      q_19 "Active",:pick=>:one,:score_code=>"pas"
      q_20 "Afraid",:pick=>:one,:score_code=>"nas"
    end

  end


end
