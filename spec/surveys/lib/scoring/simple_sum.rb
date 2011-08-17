survey "simple_sum", :irb_number=>"STUSS" do
  section "Simple Shoulder Test" do 
    grid "Check Yes or No for the following" do 
      a "Yes",:weight=>1
      a "No",:weight=>0

      q_sst_1 "Is your shoulder comfortable with your arm at rest by your side?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_2 "Does your shoulder allow you to sleep comfortably?",:pick=>:one,:score_code=>'simple_sum'
      q_sst_3 "Can you reach the small of your back to tuck in your shirt?",:pick=>:one,:score_code=>'simple_sum2'
      q_sst_ "Can you reach the small of your back to tuck in your shirt?",:pick=>:one,:score_code=>'simple_sum2'
    end
  end
end
