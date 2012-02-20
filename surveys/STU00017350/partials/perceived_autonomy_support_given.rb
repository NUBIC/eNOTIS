def perceived_autonomy_support_given
  section "PAS-R" do

    grid "Instructions. These questions are related to your team members. Teams have different styles, and we would like to know more about how you have felt about your encounters with your team. Your responses are confidential. Please be honest and candid" do 
      a "-3 strongly Disagree"
      a "-2"
      a "-1"
      a "0"
      a "1"
      a "2"
      a "3 Strongly Agree"
      q "I feel that my team cares about me as a person, regardless of my level of participation or success at losing weight." , :pick => :one
      q "I feel pressure from my teammates to perform up to their standards in this study." , :pick => :one
      q "I can be honest with my teammates, without worrying that they will reject me if I say or do the wrong thing." , :pick => :one
    end

  end
end
