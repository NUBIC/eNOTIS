survey "Simple Shoulder Test", :irb_number=>"STU00019833",:category=>"PRO" ,:score_algorithm=>'simple_sum' do
  section "Simple Shoulder Test" do 
    grid "Check Yes or No for the following" do 
      a "Yes",:weight=>1
      a "No",:weight=>0

      q_sst_1 "Is your shoulder comfortable with your arm at rest by your side?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_2 "Does your shoulder allow you to sleep comfortably?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_3 "Can you reach the small of your back to tuck in your shirt?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_4 "Can you place your hand behind your head with your elbow?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_5 "Can you place a coin on the shelf at the level of your shoulder without bending your elbow?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_6 "Can you lift one pound (a full container) to the level of your shoulder without bending your elbow?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_7 "Can you lift eight pounds  (a full pint container) to the level of your shoulder without bending your elbow??",:pick=>:one,:score_code=>'simple_sum'
      q_sst_8 "Can you carry twenty pounds at your side with affected extremity?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_9 "Do you think you can toss a softball under-hand twenty yards with the affected extremity?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_10 "Do you think you can toss a softball over-hand twenty yards with the affected extremity?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_11 "Can you wash the back of your opposite shoulder with the affected extremity?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_12 "Would your shoulder allow you to work full-time at your regular job?",:pick=>:one,:score_code=>'simple_sum'
    end
  end
end
