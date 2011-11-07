def promis_measure_qol
  section "QOL" do
    label "Please respond to each item"

    label_2 "<b>5 = Excellent
       <br/> 4 = Very good
       <br/> 3 = Good
       <br/> 2 = Fair
       <br/> 1 = Poor</b>"

    grid "In general, would you say your health is:" do
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "Excellent|Poor" , :pick => :one
    end    

    grid "In general, would you say your quality of life is:" do
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "Excellent|Poor" , :pick => :one
    end  
    
    grid "In general, how would you rate your physical health?" do
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "Excellent|Poor" , :pick => :one
    end      
    
    grid "In general, how would you rate your mental health, including your mood and your ability to think?" do
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "Excellent|Poor" , :pick => :one
    end   
    
    grid "In general, how would you rate your satisfaction with your social activities and relationships?" do
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "Excellent|Poor" , :pick => :one
    end  
    
    grid "In general, please rate how well you carry out your usual social activities and roles. (This includes activities at home, at work and in 
    your community, and responsibilites as a parent, child, spouse, employee, friend, etc.)" do
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "Excellent|Poor" , :pick => :one
    end  
       
    grid "To what extent are you able to carry out your everyday physical activities such as walking, climbing stairs, carrying groceries, or moving a chair? 
    <br/> 
      <br/><b> 5 = Completely
      <br/> 4 = Mostly
      <br/> 3 = Moderately
      <br/> 2 = A little
      <br/> 1 = Not at all</b>" do
        
      a "5"
      a "4"
      a "3"
      a "2"
      a "1"
      q "Completely|Not at all" , :pick => :one
    end     
    
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
    end                 
  end
end
