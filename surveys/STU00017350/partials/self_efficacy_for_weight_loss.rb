def self_efficacy_for_weight_loss
  section "SE" do
    label_1 "This questionnare looks at how confident you are about <b><u>losing weight</u></b> when other things get in the way. 
    Read the following items and write the number that best epresses how each item relates to you. 
    Please answer using the following 5-point scale:
      <br/>"

    label_1_2 "<b>1 = Not at all confident
      <br/> 2 = Somewhat confident
      <br/> 3 = Moderately confident
      <br/> 4 = Very confident
      <br/> 5 = Completely confident <br/></b>"

    grid_1 "" do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q_1 "I am under a lot of stress." , :pick => :one
      q_2 "I am depressed." , :pick => :one
      q_3 "I am anxious." , :pick => :one
      q_4 "I feel I don't have the time." , :pick => :one
      q_5 "I don't feel like it." , :pick => :one
      q_6 "I am busy." , :pick => :one
      q_7 "I am in a rush." , :pick => :one
      q_8 "I am tired." , :pick => :one
      q_9 "Healthy foods are not available." , :pick => :one
      q_10 "I am travelling." , :pick => :one
      q_11 "I only have unhealthy foods at home." , :pick => :one
      q_12 "I am eating at a restaurant." , :pick => :one
      q_13 "I am eating fast foods." , :pick => :one

    end

 
   label_2 "This questionnare looks at how confident you are about <b><u>exercising</u></b> when other things get in the way. 
   Read the following items and write the number that best epresses how each item relates to you. 
   Please answer using the following 5-point scale:
      <br/>"

    label_2_1 "<b>1 = Not at all confident
      <br/> 2 = Somewhat confident
      <br/> 3 = Moderately confident
      <br/> 4 = Very confident
      <br/> 5 = Completely confident <br/></b>"
    
    grid_2 "I am under a lot of stress." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"

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

     label_3_1 "<b>1 = Not at all confident
       <br/> 2 = Somewhat confident
       <br/> 3 = Moderately confident
       <br/> 4 = Very confident
       <br/> 5 = Completely confident <br/></b>"

     grid_3 "" do
       a "1"
       a "2"
       a "3"
       a "4"
       a "5"

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
       q_3l "I am eating at a restaurant.",:pick=>:one
       q_3m "I am eating fast food.",:pick=>:one
     end


     label_4 "This questionnare looks at how confident you are about <b><u>eating less saturated fat</u></b> when other things get in the way. 
      Read the following items and write the number that best epresses how each item relates to you. 
      Please answer using the following 5-point scale:
      <br/>"

      label_4_1 "<b>1 = Not at all confident
        <br/> 2 = Somewhat confident
        <br/> 3 = Moderately confident
        <br/> 4 = Very confident
        <br/> 5 = Completely confident <br/></b>"

      grid "I am under a lot of stress." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I am depressed." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I am anxious." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I feel I don't have the time." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I don't feel like it." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I am busy." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I am in a rush." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I am tired." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "Lower saturated foods are not available." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I am traveling." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I only have high saturated fat foods at home." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I am eating at a restaurant." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end

      grid "I am eating fast food." do
        a "1"
        a "2"
        a "3"
        a "4"
        a "5"
        q "Not at all confident|Completely confident" , :pick => :one
      end         
  end
end
