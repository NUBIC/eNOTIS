survey "EQ-5D" ,:irb_number=>'STU00020973' do 
  section "EQ-5D" do

    label "Please indicate which statements best describe your own health state today."

    q_eq5d_mobility "Mobility", :pick => :one
      a_1 "I have no problems in walking about"
      a_2 "I have some problems in walking about"
      a_3 "I am confined to bed"
    
    q_eq5d_selfcare  "Self-Care",:pick=>:one
      a_1 "I have no problems with self care"
      a_2 "I have some problems washing or dressing myself"
      a_3 "I am unable to wash or dress myself"

    q_eq5d_usualact "Usual Activities (e.g. work, study, housework, family or leisure activities)",:pick=>:one
      a_1 "I have no problems with performing my usual activities"
      a_2 "I have some problems with performing my usual activities"
      a_3 "I am unable to perform my usual activities"


    q_eq5d_paindiscomfort "Pain/Discomfort",:pick=>:one
      a_1 "I have no pain or discomfort"
      a_2 "I have moderate pain or discomfort"
      a_3 "I have extreme pain or discomfort"

    q_eq5d_anxietydepression "Anxiety/Depression",:pick=>:one
      a_1 "I am not anxious or depressed"
      a_2 "I am moderately anxious or depressed"
      a_3 "I am extremely anxious or depressed"
  end

  section "EQ VAS" do 

    q_eqvas_discomfort "We would like you to indicate on this scale how good or bad your own health is today, in your opinion.",:pick=>:one,:display_type => :slider
    (0..100).to_a.each{|num| a num.to_s}
  end

end


