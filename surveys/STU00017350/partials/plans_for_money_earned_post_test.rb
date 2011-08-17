def plans_for_money_earned_post_test
  section "ME-POST" do
    label "In this weight loss intervention, you had the opportunity to earn money for showing up to appointments 
    and for losing weight, and you were not given any instructions with regard to how that money was to be 
    spent. In a future study, we may assign some participants to a condition that requires that the money 
    they earn be donated to a charity of their choice."
    
    q_1 "Would you have preferred it if we required that the money you earned in this study be donated to a charity of your choice?", :pick => :one
    a_1 "Yes"
    a_2 "No"
    
    q_2 "Do you think you would have performed better (lost more weight) if we required that the money that you earned in this study be donated to a charity of your choice?", :pick => :one
    a_1 "Yes"
    a_2 "No"
  end 
end  