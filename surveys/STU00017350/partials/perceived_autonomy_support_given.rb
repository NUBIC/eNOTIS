def perceived_autonomy_support_given
  section "PAS-G" do
    label "Instructions. These questions are related to your team members. Teams have different styles, and we would like to know 
    more about how you have felt about your encounters with your team. Your responces are confidential. Please be honest and candid"
     
    grid "I feel that my team cares about me as a person, regardless of my level of participation or success at loosing weight." do
      a "-3"
      a "-2"
      a "-1"
      a "0"
      a "1"
      a "2"
      a "3"
      q "Strongly Disagree|Strongly Agree" , :pick => :one
    end

    grid "I feel pressure from my teammates to perform up to their standards in this study." do
      a "-3"
      a "-2"
      a "-1"
      a "0"
      a "1"
      a "2"
      a "3"
      q "Strongly Disagree|Strongly Agree" , :pick => :one
    end
       
    grid "I can be honest with my teammates, without worrying that they will reject me if I say or do the wrong thing." do
      a "-3"
      a "-2"
      a "-1"
      a "0"
      a "1"
      a "2"
      a "3"
      q "Strongly Disagree|Strongly Agree" , :pick => :one
    end
  end
end
