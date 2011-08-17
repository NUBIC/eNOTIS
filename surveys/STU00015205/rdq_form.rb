
survey "Reflux Disease Questionnaire",:irb_number=>"STU00015205" do
  section "Reflux Disease Questionnaire" do

    grid "Thinking about your symptoms over the last seven days, how often did you have the following?" do
      a "Did not have"
      a "Less than one day a week"
      a "One day a week"
      a "2-3 days a week"
      a "4-6 days a week"
      a "Daily"
      q "A burning feeling behind your breastbone", :pick => :one
      q "Pain behind your breastbone", :pick => :one
      q "A burning feeling in the center of the upper stomach", :pick => :one
      q "A pain in the centre of the upper stomach", :pick => :one
      q "An acid taste in your mouth", :pick => :one
      q "Unpleasant movement of material upwards from the stomach", :pick => :one
    end
    
    grid "Thinking about symptoms over the last seven days, how would you rate the following?" do
      a "Did not have"
      a "Very mild"
      a "Mild"
      a "Moderate"
      a "Moderately severe"
      a "Severe"
      q "A burning feeling behind your breastbone", :pick => :one
      q "Pain behind your breastbone", :pick => :one
      q "A burning feeling in the center of the upper stomach", :pick => :one
      q "A pain in the centre of the upper stomach", :pick => :one
      q "An acid taste in your mouth", :pick => :one
      q "Unpleasant movement of material upwards from the stomach", :pick => :one
    end
  end

end
