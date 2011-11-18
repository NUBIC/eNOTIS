def technology_acceptance_model
  section "TAM" do
    
    label_tam_instructions "Please answer the following questions to accurately describe your attitudes about the ENGAGED Smartphone (E2) application."
    
    grid "Barriers" do
      a "1- Extremely agree"
      a "2- Quite agree"
      a "3- Slightly agree"
      a "4- Neither"
      a "5- Slightly disagree"
      a "6- Quite disagree"
      a "7- Extremely disagree"
      
      q "Difficulties in finding and installing the E2 application has a negative impact on my usage.",:pick=>:one
      q "Difficult configuration of E2 has a negative impact on my usage.",:pick=>:one
      q "Poor performance of E2 has a negative aspect on my usage.",:pick=>:one
    end
  
    grid "Behavioral Control" do
      a "1- Extremely agree"
      a "2- Quite agree"
      a "3- Slightly agree"
      a "4- Neither"
      a "5- Slightly disagree"
      a "6- Quite disagree"
      a "7- Extremely disagree"
      
      q "I can use the E2 application without help from others.",:pick=>:one
      q "I have the means and resources to use the E2 application.",:pick=>:one
      q "I have the knowledge and skills to use the E2 application.",:pick=>:one
    end
    
    grid "Perceived Enjoyment" do 
      a "1- Extremely agree"
      a "2- Quite agree"
      a "3- Slightly agree"
      a "4- Neither"
      a "5- Slightly disagree"
      a "6- Quite disagree"
      a "7- Extremely disagree"
      
      q "I think it is fun to use the E2 applicaton.",:pick=>:one
      q "The E2 application brings enjoyment.",:pick=>:one
      q "I use the E2 application to kill time.",:pick=>:one
    end
    
    grid "Perceived Usefulness" do 
      a "1- Extremely agree"
      a "2- Quite agree"
      a "3- Slightly agree"
      a "4- Neither"
      a "5- Slightly disagree"
      a "6- Quite disagree"
      a "7- Extremely disagree"
      
      q "The E2 application is useful in my weight management efforts.",:pick=>:one
      q "The E2 application improves my efficiency.",:pick=>:one
      q "Using the E2 application saves time.",:pick=>:one
    end
    
    grid "Intention to Use" do
      a "1- Extremely agree"
      a "2- Quite agree"
      a "3- Slightly agree"
      a "4- Neither"
      a "5- Slightly disagree"
      a "6- Quite disagree"
      a "7- Extremely disagree"
      
      q "If it were possible, I would use the E2 application over the next two months.",:pick=>:one
      q "If it were possible, I would use the E2 application/DROID over the next year.",:pick=>:one
    end
    
    # q_1 "<i>Barriers</i>", :pick => :one
    # a "Difficulties in finding and installing the E2 application has a negative impact on my usage."
    # a "Difficult configuration of E2 has a negative impact on my usage."
    # a "Poor performance of E2 has a negative aspect on my usage."
    # 
    # q_2 "<i>Behavioral Control</i>", :pick => :one
    # a "I can use the E2 application without help from others."
    # a "I have the means and resources to use the E2 application."
    # a "I have the knowledge and skills to use the E2 application."
    # 
    # q_3 "<i>Perceived Enjoyment</i>", :pick => :one
    # a "I think it is fun to use the E2 applicaton."
    # a "The E2 application brings enjoyment."
    # a "I use the E2 application to kill time."
    # 
    # q_4 "<i>Perceived Usefulness</i>", :pick => :one
    # a "The E2 application is useful in my weight management efforts."
    # a "The E2 application improves my efficiency."
    # a "Using the E2 application saves time."  
    # 
    # q_5 "<i>Intention to Use</i>", :pick => :one
    # a "If it were possible, I would use the E2 application over the next two months."
    # a "If it were possible, I would use the E2 application/DROID over the next year."
  end
end