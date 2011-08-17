def perceived_autonomy_support_received
  section "PAS-R" do
    label "Instructions. These questions are related to your team members. Teams have different styles, and we would like to know 
    more about how you have felt about your encounters with your team. Your responces are confidential. Please be honest and candid"
     
    grid "If I feel as though a teammate of mine is not pulling his or her weight, I have sometimes used peer pressure to get them on track." do
      a "-3"
      a "-2"
      a "-1"
      a "0"
      a "1"
      a "2"
      a "3"
      q "Strongly Disagree|Strongly Agree" , :pick => :one
    end

    grid "I'm pretty accepting of my teammates level of participation/success in this study, regardless of how well or poorly they're doing" do
      a "-3"
      a "-2"
      a "-1"
      a "0"
      a "1"
      a "2"
      a "3"
      q "Strongly Disagree|Strongly Agree" , :pick => :one
    end
           
    grid "I try to convey to my teammates that my support of the is not contingent on (or tied to) how well they are doing at losing weight." do
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