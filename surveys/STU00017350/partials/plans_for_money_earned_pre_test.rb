def plans_for_money_earned_pre_test
  section "ME-PRE" do
    label "Over the course of this 12 month study, you will have an opportunity to earn up to $220 for your 
      participation.  You will receive $40 for attending the 3, 6, and 12-month follow-ups.  You will also have the 
      opportunity to win additional money through group weight loss competitions that will occur at months 3 and 6 of 
      the study, up to $50 at each time point.  You are free to spend this money on anything you like, and are in no way obligated to 
      decide what you'll spend that money on in advance.  However, some participants decide at the 
      beginning of the study what they will do with any money earn that they earn.  We're curious about how 
      that might influence people's success at changing their behavior, and so we'd like to know the following:"
    
    q_1 "How do you plan to spend the money that you may earn for participating in this research?"  
    a :text
    
    q_2 "From the options below, please select the option that best characterizes your plans: ", :pick => :one
    a_1 "I have no plans"
    a_2 "I plan to treat myself to some luxury or indulgence (e.g., clothing, a spa treatment, a toy)"
    a_3 "I plan to spend the money on something related to improving my health"
    a_4 "I plan to spend the money on someone else that I know (a friend, family member, or loved one)"
    a_5 "I plan to donate the money I earn to a charity of some kind."
    a_6 "I have other plans", :text
    
    q_please_specify "Please specify"
    dependency :rule => "B"
    condition_B :q_2, "==", :a_6
    a_1 :text
    validation :rule => "A"
    condition_A "=~", :regexp =>".{250}"
  end 
end