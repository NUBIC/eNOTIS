def group_cohesion
  section "GC" do
    grid "Please answer the following questions with regards to how you feel about being a part of your ENGAGED team." do 
     
      a_1 "Strongly disagree"
      a_2 "Quite disagree"
      a_3 "Slightly disagree"
      a_4 "Neither"
      a_5 "Slightly agree"
      a_6 "Quite agree"
      a_7 "Strongly agree"
      q_1 "I feel that I belong to this group", :pick => :one
      q_2 "I am happy to be part of this group", :pick => :one
      q_3 "I see myself as part of this group", :pick => :one
      q_4 "This group is one of the best anywhere", :pick => :one
      q_5 "I feel that I am a member of this group", :pick => :one
      q_6 "I am content to be a part of this group", :pick => :one
    end

  end
end
