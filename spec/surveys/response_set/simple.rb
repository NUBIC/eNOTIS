survey "simple", :irb_number=>"STUSS"do
  section "Simple Shoulder Test" do 

      q_sst_1 "Is your shoulder comfortable with your arm at rest by your side?",:pick=>:one
      a_1 "Yes"
      a_2 "No"
      q_sst_2 "Does your shoulder allow you to sleep comfortably?",:pick=>:one
      a_1 "Yes"
      a_2 "No"
      q_sst_3 "Can you reach the small of your back to tuck in your shirt?",:pick=>:one
      a_1 "Yes"
      a_2 "No"
  end
end
