survey "GerdQ",:irb_number=>"STU00015205",:score_configurations_attributes=>[{:name=>"Total Score",:algorithm=>'total_sum'},{:name=>"Disease Impact Score",:algorithm=>'partial_sum',:question_code=>'disease_impact'}] do
  
  section "GerdQ" do

    label "Think about the past seven days…"

    image "surveyor/STU00015205/gerd_person.png"

    q_ec_gerdq1 "How often did you have a burning feeling behind your breastbone (heartburn)?", :pick => :one
      a_0 "0 days",:weight=>0
      a_1 "1 day",:weight=>1
      a_2 "2-3 days",:weight=>2
      a_3 "4-7 days",:weight=>3

    q_ec_gerdq2 "How often did you have stomach contents (liquid or food) moving upwards to your throat or mouth (regurgitation)?",:pick=>:one
      a_0 "0 days",:weight=>0
      a_1 "1 day",:weight=>1
      a_2 "2-3 days",:weight=>2
      a_3 "4-7 days",:weight=>3

    q_ec_gerdq3 "How often did you have a pain in the center of the upper stomach?",:pick=>:one
      a_3 "0 days",:weight=>3
      a_2 "1 day",:weight=>2
      a_1 "2-3 days",:weight=>1
      a_0 "4-7 days",:weight=>0


    q_ec_gerdq4 "How often did you have nausea?",:pick=>:one
      a_3 "0 days",:weight=>3
      a_2 "1 day",:weight=>2
      a_1 "2-3 days",:weight=>1
      a_0 "4-7 days",:weight=>0


    q_ec_gerdq5 "How often did you have difficulty getting a good night’s sleep because of your heartburn and/or regurgitation?",:pick=>:one,:score_code=>"disease_impact"
      a_0 "0 days",:weight=>0
      a_1 "1 day",:weight=>1
      a_2 "2-3 days",:weight=>2
      a_3 "4-7 days",:weight=>3


    q_ec_gerdq6 "How often did you take additional medication for your heartburn and/or regurgitation other than what the physician told you to take (such as Tums, Rolaids, Maalox?)",:pick=>:one,:score_code=>"disease_impact"
      a_0 "0 days",:weight=>0
      a_1 "1 day",:weight=>1
      a_2 "2-3 days",:weight=>2
      a_3 "4-7 days",:weight=>3
  end
end

