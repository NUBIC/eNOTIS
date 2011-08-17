def condition_preference_pre_test
  section "CP-PRE" do
    label "Which treatment group..."
  
    q_1 "would you pick for yourself?", :pick => :one
    a_1 "Tech-Supported"
    a_2 "Standard"
    a_3 "Self-guided"
    
    q_2 "would work best for you?", :pick => :one
    a_1 "Tech-Supported"
    a_2 "Standard"
    a_3 "Self-guided"
    
    q_3 "would you find most enjoyable?", :pick => :one
    a_1 "Tech-Supported"
    a_2 "Standard"
    a_3 "Self-guided"
  end
end
