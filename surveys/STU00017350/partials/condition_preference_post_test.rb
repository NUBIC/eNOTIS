def  condition_preference_post_test
  section "CP-POST" do
    label "If you could have chosen which treatment you received at the beginning of the the study, which treatment group..."
     
    q_1 "would you have picked for yourself?", :pick => :one
    a_1 "Tech-Supported"
    a_2 "Standard"
    a_3 "Self-guided"
       
    q_2 "would have worked best for you?", :pick => :one
    a_1 "Tech-Supported"
    a_2 "Standard"
    a_3 "Self-guided"
       
    q_3 "would you have found most enjoyable?", :pick => :one
    a_1 "Tech-Supported"
    a_2 "Standard"
    a_3 "Self-guided"
  end
end
