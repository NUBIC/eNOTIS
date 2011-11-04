def therapeutic_alliance
  section "T-ALL" do
    label_1_1 "Below, there are sentences that describe some of the different ways a person might think or feel about his or her coach/group leader.
    Below each statement inside there is a seven point scale"
    
    label_1_2 "<b>1 = Never
      <br/> 2 = Rarely
      <br/> 3 = Occasionally
      <br/> 4 = Sometimes
      <br/> 5 = Often
      <br/> 6 = Very Often
      <br/> 7 = Always<br/></b>"

    label_1_3 "If the statement describes the way you <b>always</b> feel (or think) select the number <b>7</b>; if it never applies to you select the number <b>1</b>. 
    Use the numbers in between to describe the variations between these extremes."
    
    grid "My coach  and I agree about the things I will need to do in therapy to help improve my situation." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "What I am doing in therapy gives me new ways of looking at my problem." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "I believe my coach likes me." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "My coach does not understand what I am trying to accomplish in therapy." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "I am confident in my coach 's ability to help me." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "My coach and I are working towards mutually agreed upon goals." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end 
    grid "I feel that my coach appreciates me." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end 
    grid "We agree on what is important for me to work on." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "My coach and I trust one another." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "My coach and I have different ideas on what my problems are." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "We have established a good understanding of the kind of changes that would be good for me." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end
    grid "I believe the way we are working with my problem is correct." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      a "6"
      a "7"
      q "Never|Always" , :pick => :one
    end            
  end
end    

