survey "PROMIS SF v1.0-Depression 4a" ,:irb_number=>"STU00015205" ,:score_algorithm=>'simple_sum'do 

  section "Depression" do 
    label "Please respond to each item by marking one box per row"

    grid "In the past 7 days..." do 
      a_1 "Never",:weight=>1
      a_2 "Rarely",:weight=>2
      a_3 "Sometimes",:weight=>3
      a_4 "Often",:weight=>4
      a_5 "Always",:weight=>5
     
      q_ec_depression1 "I felt worthless...",:pick=>:one,:score_code=>'simple_sum'
      q_ec_depression2 "I felt helpless...",:pick=>:one,:score_code=>'simple_sum'
      q_ec_depression3 "I felt depressed...",:pick=>:one,:score_code=>'simple_sum'
      q_ec_depression4 "I felt hopeless...",:pick=>:one,:score_code=>'simple_sum'

    end
  end

end
