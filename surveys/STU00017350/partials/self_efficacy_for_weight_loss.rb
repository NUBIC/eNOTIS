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
    grid "Healthy foods are not available." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end
    grid "I am travelling." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end  
    grid "I only have unhealthy foods at home." do
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

    grid "I am eating fast foods." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
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

    grid "I am alone." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "I have to exercise alone." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "My exercise partner decides not to exercise that day." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "I don't have access to exercise equipment." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "I am travelling." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "My gym is closed." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "My friends don't want me to exercise." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "My significant other doesn't want me to exercise." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "I am spending time with friends or family who do not exercise." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "It's raining or snowing." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end
    
    grid "It's cold outside." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
    end

    grid "The roads or sidewalks are snowy." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all confident|Completely confident" , :pick => :one
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

     grid "Reduced calorie foods are not available." do
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
     
     grid "I only have high calorie foods at home." do
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