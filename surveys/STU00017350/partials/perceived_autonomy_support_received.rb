def perceived_autonomy_support_received
  section "PAS-G" do
    grid "Instructions. These questions are related to your team members. Teams have different styles, and we would like to know more about how you have felt about your encounters with your team. Your responses are confidential. Please be honest and candid" do
      a "-3 Strongly Disagree"
      a "-2"
      a "-1"
      a "0"
      a "1"
      a "2"
      a "3 Strongly Agree"
      q "If I feel as though a teammate of mine is not pulling his or her weight, I have sometimes used peer pressure to get them on track." , :pick => :one
      q "I'm pretty accepting of my teammates level of participation/success in this study, regardless of how well or poorly they're doing" , :pick => :one
      q "I try to convey to my teammates that my support of them is not contingent on (or tied to) how well they are doing at losing weight." , :pick => :one
    end

  end
end
