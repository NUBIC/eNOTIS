def promis_measure_qol
  section "QOL" do
    label "Please respond to each item"

    grid do
      a_1 "1 = Poor"
      a_2 "2 = Fair"
      a_3 "3 = Good"
      a_4 "4 = Very good"
      a_5 "5 = Excellent"
      
      q_1 "In general, would you say your health is:", :pick => :one
      q_2 "In general, would you say your quality of life is:", :pick => :one
      q_3 "In general, how would you rate your physical health?", :pick => :one
      q_4 "In general, how would you rate your mental health, including your mood and your ability to think?", :pick => :one
      q_5 "In general, how would you rate your satisfaction with your social activities and relationships?", :pick => :one
      q_6 "In general, please rate how well you carry out your usual social activities and roles. (This includes activities at home, at work and in 
      your community, and responsibilites as a parent, child, spouse, employee, friend, etc.)", :pick => :one
    end
       
    grid do
      a_1 "1 = Not at all"
      a_2 "2 = A little"
      a_3 "3 = Moderately"
      a_4 "4 = Mostly"
      a_5 "5 = Completely"
      
      q "To what extent are you able to carry out your everyday physical activities such as walking, climbing stairs, carrying groceries, or moving a chair?", :pick => :one
    end     
    
<<<<<<< HEAD
    grid "In the past 7 days, how often have you been bothered by emotional problems such as feeling anxious, depressed or irritable?
        <br/>
          <br/><b> 5 = Never
          <br/> 4 = Rarely
          <br/> 3 = Sometimes
          <br/> 2 = Often
          <br/> 1 = Always</b>" do
                
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "Never|Always" , :pick => :one
    end  
    
    grid "In the past 7 days, how would you rate your fatigue on average? 
      <br/>
        <br/><b> 5 = None
        <br/> 4 = Mild
        <br/> 3 = Moderate
        <br/> 2 = Severe
        <br/> 1 = Very severe</b>" do
                
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "None|Very severe" , :pick => :one
    end
    
    grid "In the past 7 days, how would you rate your pain on average?" do
      a "0"
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      a "8"
      a "9"
      a "10"                    
      q "No pain|Worst imaginable pain" , :pick => :one
=======
    grid do
      a_1 "1 = Always"
      a_2 "2 = Often"
      a_3 "3 = Sometimes"
      a_4 "4 = Rarely"
      a_5 "5 = Never"
                        
      q "In the past 7 days, how often have you been bothered by emotional problems such as feeling anxious, depressed or irritable?", :pick => :one
    end  
    
    grid do
      a_1 "1 = Very severe"
      a_2 "2 = Severe"
      a_3 "3 = Moderate"
      a_4 "4 = Mild"
      a_5 "5 = None"
            
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
>>>>>>> master
    end                 
  end
end
