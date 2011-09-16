survey "Heartburn Symptom Experience Questionnaire" ,:irb_number=>'STU00015205',:score_configurations_attributes=>[{:name=>"catastrophizing scale",:algorithm=>'total_sum'}], :is_public => true do 
  section "main" do

    label "We are interested in the types of thoughts and feelings that you have when you experience heartburn sensations. Listed below are 13 statements describing different thoughts and feelings that may be associated with the discomfort in your chest. <strong>Using the following scale, please indicate the degree to which you have these thoughts and feelings when you are experiencing heartburn symptoms.</strong>"

    grid "When I experience heartburn symptoms..." do

      a_1 "Not at all",:weight=>0
      a_2 "To a slight degree",:weight=>1
      a_3 "To a moderate degree",:weight=>2
      a_4 "To a great degree",:weight=>3
      a_5 "All the time",:weight=>4

      q_hse_1 "I worry all the time about whether the pain will end",:pick=>:one
      q_hse_2 "I feel I can’t go on",:pick=>:one
      q_hse_3 "It’s terrible and I think it’s never going to get any better",:pick=>:one
      q_hse_4 "It’s awful and I feel that it overwhelms me",:pick=>:one
      q_hse_5 "I feel I can’t stand it anymore",:pick=>:one
      q_hse_6 "I become afraid that the discomfort will get worse",:pick=>:one
      q_hse_7 "I keep thinking of other uncomfortable events",:pick=>:one
      q_hse_8 "I anxiously want the discomfort to go away",:pick=>:one
      q_hse_9 "I can’t seem to keep it out of my mind",:pick=>:one
      q_hse_10 "I keep thinking about how much it hurts",:pick=>:one
      q_hse_11 "I keep thinking how badly I want the pain to stop",:pick=>:one
      q_hse_12 "There’s nothing I can do to reduce the intensity of the discomfort",:pick=>:one
      q_hse_13 "I wonder whether something serious may happen",:pick=>:one
    end
  end
end
