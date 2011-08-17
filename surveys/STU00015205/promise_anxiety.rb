survey "PROMIS SF v1.0-Anxiety 4a",:irb_number=>"STU00015205" ,:score_algorithm=>'simple_sum'do 
  section "Anxiety" do 
    label "Please respond to each item by marking one box per row"
    grid "In the past 7 days…" do 
      a_1 "Never",:weight=>1
      a_2 "Rarely",:weight=>2
      a_3 "Sometimes",:weight=>3
      a_4 "Often",:weight=>4
      a_5 "Always",:weight=>5

      q_ec_anxiety1 "I felt fearful...",:pick=>:one,:score_code=>'simple_sum'
      q_ec_anxiety2 "I found it hard to focus on anything other than my anxiety...",:pick=>:one,:score_code=>'simple_sum'
      q_ec_anxiety3 "My worries overwhelmed me...",:pick=>:one,:score_code=>'simple_sum'
      q_ec_anxiety4 "I felt uneasy...",:pick=>:one,:score_code=>'simple_sum'
    end
  end
end
