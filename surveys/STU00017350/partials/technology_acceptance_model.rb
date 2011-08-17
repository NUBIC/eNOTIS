def technology_acceptance_model
  section "TAM" do
    q_1 "<i>Barriers</i>", :pick => :one
    a "Difficulties in finding and installing the E2 application has a negative impact on my usage."
    a "Difficult configuration of E2 has a negative impact on my usage."
    a "Poor performance of E2 has a negative aspect on my usage."

    q_2 "<i>Behavioral Control</i>", :pick => :one
    a "I can use the E2 application without help from others."
    a "I have the means and resources to use the E2 application."
    a "I have the knowledge and skills to use the E2 application."
    
    q_3 "<i>Perceived Enjoyment</i>", :pick => :one
    a "I think it is fun to use the E2 applicaton."
    a "The E2 application brings enjoyment."
    a "I use the E2 application to kill time."    

    q_4 "<i>Perceived Usefulness</i>", :pick => :one
    a "The E2 application is useful in my weight management efforts."
    a "The E2 application improves my efficiency."
    a "Using the E2 application saves time."  

    q_5 "<i>Intention to Use</i>", :pick => :one
    a "If it were possible, I would use the E2 application over the next two months."
    a "If it were possible, I would use the E2 application/DROID over the next year."
  end
end