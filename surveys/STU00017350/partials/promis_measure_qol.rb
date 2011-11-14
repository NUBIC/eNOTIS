def promis_measure_qol
  section "QOL" do
    label "Please respond to each item"

    grid do
      a_1 "1 = Poor", :display_order => 0
      a_2 "2 = Fair", :display_order => 1
      a_3 "3 = Good", :display_order => 2
      a_4 "4 = Very good", :display_order => 3
      a_5 "5 = Excellent", :display_order => 4
      
      q_1 "In general, would you say your health is:", :pick => :one
      q_2 "In general, would you say your quality of life is:", :pick => :one
      q_3 "In general, how would you rate your physical health?", :pick => :one
      q_4 "In general, how would you rate your mental health, including your mood and your ability to think?", :pick => :one
      q_5 "In general, how would you rate your satisfaction with your social activities and relationships?", :pick => :one
      q_6 "In general, please rate how well you carry out your usual social activities and roles. (This includes activities at home, at work and in 
      your community, and responsibilities as a parent, child, spouse, employee, friend, etc.)", :pick => :one
    end
       
    grid do
      a_1 "1 = Not at all", :display_order => 0
      a_2 "2 = A little", :display_order => 1
      a_3 "3 = Moderately", :display_order => 2
      a_4 "4 = Mostly", :display_order => 3
      a_5 "5 = Completely", :display_order => 4
      
      q "To what extent are you able to carry out your everyday physical activities such as walking, climbing stairs, carrying groceries, or moving a chair?", :pick => :one
    end     
    
    grid do
      a_1 "1 = Always", :display_order => 0
      a_2 "2 = Often", :display_order => 1
      a_3 "3 = Sometimes", :display_order => 2
      a_4 "4 = Rarely", :display_order => 3
      a_5 "5 = Never", :display_order => 4
                        
      q "In the past 7 days, how often have you been bothered by emotional problems such as feeling anxious, depressed or irritable?", :pick => :one
    end  
    
    grid do
      a_1 "1 = Very severe", :display_order => 0
      a_2 "2 = Severe", :display_order => 1
      a_3 "3 = Moderate", :display_order => 2
      a_4 "4 = Mild", :display_order => 3
      a_5 "5 = None", :display_order => 4
            
      q "In the past 7 days, how would you rate your fatigue on average?", :pick => :one
    end
    
    grid do
      a_0 "0", :display_order => 0
      a_1 "1", :display_order => 1
      a_2 "2", :display_order => 2
      a_3 "3", :display_order => 3
      a_4 "4", :display_order => 4
      a_5 "5", :display_order => 5
      a_6 "6", :display_order => 6
      a_7 "7", :display_order => 7
      a_8 "8", :display_order => 8
      a_9 "9", :display_order => 9
      a_10 "10", :display_order => 10
      q "In the past 7 days, how would you rate your pain on average?", :pick => :one
    end                 
  end
end
