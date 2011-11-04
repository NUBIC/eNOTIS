def self_efficacy_for_weight_loss
  section "SE" do
    label_1 "This questionnare looks at how confident you are about <b><u>losing weight</u></b> when other things get in the way. 
    Read the following items and write the number that best epresses how each item relates to you. 
    Please answer using the following 5-point scale:
      <br/>"

    grid_1 "" do
      a "1 = Not at all confident"
      a "2 = Somewhat confident"
      a "3 = Moderately confident"
      a "4 = Very confident"
      a "5 = Completely confident"
      q_1 "I am under a lot of stress." , :pick => :one
      q_2 "I am depressed." , :pick => :one
      q_3 "I am anxious." , :pick => :one
      q_4 "I feel I don't have the time." , :pick => :one
      q_5 "I don't feel like it." , :pick => :one
      q_6 "I am busy." , :pick => :one
      q_7 "I am in a rush." , :pick => :one
      q_8 "I am tired." , :pick => :one
      q_9 "Healthy foods are not available." , :pick => :one
      q_10 "I am traveling.", :pick => :one
      q_11 "I only have unhealthy foods at home." , :pick => :one
      q_12 "I am eating at a restaurant." , :pick => :one
      q_13 "I am eating fast foods." , :pick => :one
    end
 
    label_2 "This questionnare looks at how confident you are about <b><u>exercising</u></b> when other things get in the way. 
    Read the following items and write the number that best epresses how each item relates to you. 
    Please answer using the following 5-point scale:<br/>"

    grid_2 "" do
      a "1 = Not at all confident"
      a "2 = Somewhat confident"
      a "3 = Moderately confident"
      a "4 = Very confident"
      a "5 = Completely confident"
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
      q_2k "I am travelling." , :pick => :one
      q_2l "My gym is closed." , :pick => :one
      q_2m "My friends don't want me to exercise." , :pick => :one
      q_2n "I am spending time with friends or family who do not exercise.",:pick => :one
      q_2o "It's raining or snowing.",:pick => :one
      q_2p "It's cold outside.",:pick => :one
      q_2q "The roads or sidewalks are snowy.",:pick => :one
    end

    
    label_3 "This questionnare looks at how confident you are about <b><u>eating fewer calories</u></b> when other things get in the way. 
      Read the following items and write the number that best epresses how each item relates to you. 
      Please answer using the following 5-point scale:
       <br/>"

    grid_3 "" do
      a "1 = Not at all confident"
      a "2 = Somewhat confident"
      a "3 = Moderately confident"
      a "4 = Very confident"
      a "5 = Completely confident"
      q_1 "I am under a lot of stress." , :pick => :one
      q_2 "I am depressed." , :pick => :one
      q_3 "I am anxious." , :pick => :one
      q_4 "I feel I don't have the time." , :pick => :one
      q_5 "I don't feel like it." , :pick => :one
      q_6 "I am busy." , :pick => :one
      q_7 "I am in a rush." , :pick => :one
      q_8 "I am tired." , :pick => :one
      q_9 "Reduced calorie foods are not available." , :pick => :one
      q_10 "I am travelling." , :pick => :one
      q_11 "I only have high calorie foods at home." , :pick => :one
      q_12 "I am eating at a restaurant." , :pick => :one
      q_13 "I am eating fast foods." , :pick => :one
    end


     label_4 "This questionnare looks at how confident you are about <b><u>eating less saturated fat</u></b> when other things get in the way. 
      Read the following items and write the number that best epresses how each item relates to you. 
      Please answer using the following 5-point scale:<br/>"

      label_4_1 "<b>1 = Not at all confident
        <br/> 2 = Somewhat confident
        <br/> 3 = Moderately confident
        <br/> 4 = Very confident
        <br/> 5 = Completely confident <br/></b>"

      grid_5 "" do
        a "1 = Not at all confident"
        a "2 = Somewhat confident"
        a "3 = Moderately confident"
        a "4 = Very confident"
        a "5 = Completely confident"
        q_1 "I am under a lot of stress." , :pick => :one
        q_2 "I am depressed." , :pick => :one
        q_3 "I am anxious." , :pick => :one
        q_4 "I feel I don't have the time." , :pick => :one
        q_5 "I don't feel like it." , :pick => :one
        q_6 "I am busy." , :pick => :one
        q_7 "I am in a rush." , :pick => :one
        q_8 "I am tired." , :pick => :one
        q_9 "Lower saturated foods are not available." , :pick => :one
        q_10 "I am travelling." , :pick => :one
        q_11 "I only have high saturated fat foods at home." , :pick => :one
        q_12 "I am eating at a restaurant." , :pick => :one
        q_13 "I am eating fast foods." , :pick => :one
      end
        
  end
end
