survey "Impaction Dysphagia Questionnaire" ,:irb_number=>'STU00015205',:is_public =>true  do 
  section "main" do

    grid "Over the past 30 days, on average, how often have you had the following?" do
      a_1 "Never"
      a_2 "Less than once a month"
      a_3 "1-9 times a month"
      a_4 "10-19 times a month"
      a_5 "20-29 times a month"
      a_6 "Daily"
      q_idq_30_days_1 "Trouble eating solid food (meat, bread)",:pick=>:one
      q_idq_30_days_2 "Trouble swallowing liquids",:pick=>:one
      q_idq_30_days_3 "Pain while swallowing",:pick=>:one
      q_idq_30_days_4 "Trouble eating soft foods (yogurt, jello, pudding)",:pick=>:one
      q_idq_30_days_5 "Coughing or choking while swallowing foods",:pick=>:one
    end

    grid "Over the past year (12 months), how often have you had the following?" do 
      a_1 "Never"
      a_2 "Less than once a month"
      a_3 "1-9 times a month"
      a_4 "10-19 times a month"
      a_5 "20-29 times a month"
      a_6 "Daily"

      q_idq_12_months_6 "Food stuck in throat or esophagus for more than 30 minutes",:pick=>:one
      q_idq_12_months_7 "An emergency room visit because of food being stuck in throat or esophagus",:pick=>:one
    end
    
    grid "Over the past 180 days (6 months), on average, how would you rate your discomfort or pain during swallowing?" do
      a_1 "None"
      a_2 "Very mild"
      a_3 "Mild"
      a_4 "Moderate"
      a_5 "Moderately severe"
      a_6 "Severe"

      q_idq_180_days_1 "Eating solids (meat, bread)",:pick=>:one
      q_idq_180_days_2 "Eating soft foods (yogurt, jello, pudding)",:pick=>:one
      q_idq_180_days_3 "Drinking liquids",:pick=>:one
    end
  end
end
