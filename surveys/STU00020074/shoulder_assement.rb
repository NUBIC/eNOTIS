survey "Shoulder Form", :irb_number=>"STU00020074",:category=>"PRO" do

  section "Shoulder Assesment" do 
    repeater " " do 
      question_side  "side",:pick=>:one, :display_type => :dropdown
        a_1 "Right"
        a_2 "Left"
      question_device "Device",:pick=>:one, :display_type => :dropdown
        a_1 "RSP"
        a_2 "TSA"
        a_3 "Hemi"

      question_dos "DOS"
        a :string
    end

    grid "Select the response that indicates your ability to do the following with your LEFT ARM" do 
      a "Unable",:weight=>0
      a "Very Difficult",:weight=>1
      a "Somewhat Difficult",:weight=>2
      a "Normal",:weight=>3

      q "Put on a coat", :pick=>:one,:score_code=>"adl"
      q "Sleep on your painful or affected side", :pick=>:one,:score_code=>"adl"
      q  "Wash back/do up bra in back", :pick=>:one,:score_code=>"adl"
      q "Manage  toileting", :pick=>:one,:score_code=>"adl"
      q "Comb/Wash Hair", :pick=>:one,:score_code=>"adl"
      q "Reach a high shelf", :pick=>:one,:score_code=>"adl"
      q  "Lift 10 lbs. above shoulder", :pick=>:one,:score_code=>"adl"
      q "Throw a ball overhand", :pick=>:one,:score_code=>"adl"
      q "Do usual work-list", :pick=>:one,:score_code=>"adl"
      q "Do usual sport-list", :pick=>:one,:score_code=>"adl"
    end

    grid "Select the response that indicates your ability to do the following with your RIGHT ARM" do 
      a "Unable",:weight=>0
      a "Very Difficult",:weight=>1
      a "Somewhat Difficult",:weight=>2
      a "Normal",:weight=>3

      q "Put on a coat",:pick=>:one,:score_code=>"adl"
      q "Sleep on your painful or affected side",:pick=>:one,:score_code=>"adl"
      q  "Wash back/do up bra in back",:pick=>:one,:score_code=>"adl"
      q "Manage  toileting",:pick=>:one,:score_code=>"adl"
      q "Comb/Wash Hair",:pick=>:one,:score_code=>"adl"
      q "Reach a high shelf",:pick=>:one,:score_code=>"adl"
      q  "Lift 10 lbs. above shoulder",:pick=>:one,:score_code=>"adl"
      q "Throw a ball overhand",:pick=>:one,:score_code=>"adl"
      q "Do usual work-list",:pick=>:one,:score_code=>"adl"
      q "Do usual sport-list",:pick=>:one,:score_code=>"adl"
    end

    q_pain "On the following scale of 0 - 10, how bad is your pain today?",:pick=>:one,:score_code=>"vas_pain",:display_type => :slider, :help_text=>"0 = No pain at all, 10 = Pain as bad as it can be"
    (0..10).to_a.each{|num| a num.to_s, :weight=> num}

        
    q_function "On the following scale of 0 - 10, what do you consider to be the current overall function of your shoulder?",:pick=>:one,:display_type => :slider, :help_text=>"0 = My shoulder is useless, 10 = My shoulder is normal"
    (0..10).to_a.each{|num| a num.to_s}

  end

end
