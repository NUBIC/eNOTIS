def dpp_group_lifestyle_balance_materials
  section "DVD" do
    q_number_of_sessions_watched "How many DPP Group Lifestyle Balance sessions have you watched?", :pick => :one
    a_0 "0 sessions"
    a_1_3 "1-3 sessions"
    a_4_7 "4-7 sessions"
    a_8_11 "8-11 sessions"
    a_12 "12 sessions"
    
    q_number_corresponding_lessons_reviewed "How many of the 12 corresponding lessons in the notebook did you review", :pick => :one
    a_0 "0 lessons"
    a_1_3 "1-3 lessons"
    a_4_7 "4-7 lessons"
    a_8_11 "8-11 lessons"
    a_12 "12 lessons"
    
    q_homework_activities "How often did you complete the homework activities under the \"To Do\" section of the session handouts?", :pick => :one
    a_always "Always"
    a_often "Often"
    a_rarely "Rarely"
    a_never "Never"
    
    q_recommend_dvd "Would you recommend these DVD's to anyone looking to lose weight", :pick => :one
    a_yes "Yes"
    a_no "No"
    a_maybe "Maybe"
    
    q_suggestions "Do you have any comments or suggestions regarding the use of the Group Lifestyle Balance Sessions or Lessons?"
    a :text
  end
end