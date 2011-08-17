survey "Patient Satisfaction", :irb_number=>"STU009999003",:public=>true,:category=>"PRO" do

  section "Patient Satisfaction" do 
    q_ps_1 "How satisfied are you with your current outcome?",:pick=>:one,:display_type => :slider, :help_text=>"0 = Unsatisfied, 10 = Satisfied"
    (0..10).to_a.each{|num| a num.to_s}
    q_ps_2 "Based on your outcome, would you still have the same procedure performed?",:pick=>:one
      a_1 "Yes"
      a_2 "No"
  
    q_ps_3 "May other patients who may be a candidate for this surgery contact you to help them make their decision regarding surgery?",:pick=>:one
      a_1 "Yes"
      a_2 "No"

    q_ps_4 "Comments"
      a :text
  end
end
