def self_efficacy_for_weight_loss
  section "SE" do
    grid_1 "This questionnaire looks at how confident you are about <b><u>losing weight</u></b> when other things get in the way. 
      Read the following items and write the number that best expresses how each item relates to you. 
      Please answer using the following 5-point scale:" do
      
      a "1 = Not at all confident", :display_order => 0
      a "2 = Somewhat confident", :display_order => 1
      a "3 = Moderately confident", :display_order => 2
      a "4 = Very confident", :display_order => 3
      a "5 = Completely confident", :display_order => 4
      q_1a "I am under a lot of stress." , :pick => :one
      q_1b "I am depressed." , :pick => :one
      q_1c "I am anxious." , :pick => :one
      q_1d "I feel I don't have the time." , :pick => :one
      q_1e "I don't feel like it." , :pick => :one
      q_1f "I am busy." , :pick => :one
      q_1g "I am in a rush." , :pick => :one
      q_1h "I am tired." , :pick => :one
      q_1i "Healthy foods are not available." , :pick => :one
      q_1j "I am traveling.", :pick => :one
      q_1k "I only have unhealthy foods at home." , :pick => :one
      q_1l "I am eating at a restaurant." , :pick => :one
      q_1m "I am eating fast foods." , :pick => :one
    end

    grid_2 "This questionnaire looks at how confident you are about <b><u>exercising</u></b> when other things get in the way. 
      Read the following items and write the number that best expresses how each item relates to you. 
      Please answer using the following 5-point scale" do
      
      a "1 = Not at all confident", :display_order => 0
      a "2 = Somewhat confident", :display_order => 1
      a "3 = Moderately confident", :display_order => 2
      a "4 = Very confident", :display_order => 3
      a "5 = Completely confident", :display_order => 4
      q_2a "I am under a lot of stress." , :pick => :one
      q_2b "I am depressed." , :pick => :one
      q_2c "I am anxious." , :pick => :one
      q_2d "I feel I don't have the time." , :pick => :one
      q_2e "I don't feel like it." , :pick => :one
      q_2f "I am busy." , :pick => :one
      q_2g "I am alone." , :pick => :one
      q_2h "I have to exercise alone." , :pick => :one
      q_2i "My exercise partner decides not to exercise that day" , :pick => :one
      q_2j "I don't have access to exercise equipment." , :pick => :one
      q_2k "I am traveling." , :pick => :one
      q_2l "My gym is closed." , :pick => :one
      q_2m "My friends don't want me to exercise." , :pick => :one
      q_2n "I am spending time with friends or family who do not exercise.",:pick => :one
      q_2o "It's raining or snowing.",:pick => :one
      q_2p "It's cold outside.",:pick => :one
      q_2q "The roads or sidewalks are snowy.",:pick => :one
      q_2r "My significant other doesn’t want me to exercise.",:pick => :one
    end

    grid_3 "This questionnaire looks at how confident you are about <b><u>eating fewer calories</u></b> when other things get in the way. 
      Read the following items and write the number that best expresses how each item relates to you. 
      Please answer using the following 5-point scale:" do
      
      a "1 = Not at all confident", :display_order => 0
      a "2 = Somewhat confident", :display_order => 1
      a "3 = Moderately confident", :display_order => 2
      a "4 = Very confident", :display_order => 3
      a "5 = Completely confident", :display_order => 4
      q_3a "I am under a lot of stress." , :pick => :one
      q_3b "I am depressed." , :pick => :one
      q_3c "I am anxious." , :pick => :one
      q_3d "I feel I don't have the time." , :pick => :one
      q_3e "I don't feel like it." , :pick => :one
      q_3f "I am busy." , :pick => :one
      q_3g "I am in a rush." , :pick => :one
      q_3h "I am tired." , :pick => :one
      q_3i "Reduced calorie foods are not available." , :pick => :one
      q_3j "I am traveling." , :pick => :one
      q_3k "I only have high calorie foods at home." , :pick => :one
      q_3l "I am eating at a restaurant." , :pick => :one
      q_3m "I am eating fast foods." , :pick => :one
    end

    grid_4 "This questionnaire looks at how confident you are about <b><u>eating less saturated fat</u></b> when other things get in the way. 
      Read the following items and write the number that best expresses how each item relates to you. 
      Please answer using the following 5-point scale:" do
      
      a "1 = Not at all confident", :display_order => 0
      a "2 = Somewhat confident", :display_order => 1
      a "3 = Moderately confident", :display_order => 2
      a "4 = Very confident", :display_order => 3
      a "5 = Completely confident", :display_order => 4
      q_4a "I am under a lot of stress." , :pick => :one
      q_4b "I am depressed." , :pick => :one
      q_4c "I am anxious." , :pick => :one
      q_4d "I feel I don't have the time." , :pick => :one
      q_4e "I don't feel like it." , :pick => :one
      q_4f "I am busy." , :pick => :one
      q_4g "I am in a rush." , :pick => :one
      q_4h "I am tired." , :pick => :one
      q_4i "Lower saturated foods are not available." , :pick => :one
      q_4j "I am traveling." , :pick => :one
      q_4k "I only have high saturated fat foods at home." , :pick => :one
      q_4l "I am eating at a restaurant." , :pick => :one
      q_4m "I am eating fast foods." , :pick => :one
    end
  end
end
