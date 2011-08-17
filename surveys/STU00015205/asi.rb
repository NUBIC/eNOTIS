survey "Anxiety Sensitivity Inventory" ,:irb_number=>'STU00015205',:score_configurations_attributes=>[{:name=>'Anxiety Sensitivity Index',:algorithm=>'total_sum'}] do 
  section "main" do

    grid "Choose the one phrase that best represents the extent to which
    you agree with the item. If any of the items concern something that is not part of your experience (e.g., 'It scares me when I feel shaky' for someone who has never trembled or had the 'shakes'), answer on the basis of how you think you might feel if you had such an experience. Otherwise, answer all items on the basis of your own experience.." do

      a_1 "Very Little",:weight=>0
      a_2 "A Little",:weight=>1
      a_3 "Some",:weight=>2
      a_4 "Much",:weight=>3
      a_5 "Very Much",:weight=>4

      q_asi_1 "It is important to me not to appear nervous.",:pick=>:one
      q_asi_2 "When I cannot keep my mind on a task, I worry that I might be going crazy.",:pick=>:one
      q_asi_3 "It scares me when I feel 'shaky' (trembling).",:pick=>:one
      q_asi_4 "It scares me when I feel faint.",:pick=>:one
      q_asi_5 "It is important to me to stay in control of my emotions.",:pick=>:one
      q_asi_6 "It scares me when my heart beats rapidly.",:pick=>:one
      q_asi_7 "It embarrasses me when my stomach growls.",:pick=>:one
      q_asi_8 "It scares me when I am nauseous.",:pick=>:one
      q_asi_9 "When I notice that my heart is beating rapidly, I worry that I might have a heart attack.",:pick=>:one
      q_asi_10 "It scares me when I become short of breath.",:pick=>:one
      q_asi_11 "When my stomach is upset, I worry that I might be seriously ill.",:pick=>:one
      q_asi_12 "It scares me when I am unable to keep my mind on a task.",:pick=>:one
      q_asi_13 "Other people notice when I feel shaky.",:pick=>:one
      q_asi_14 "Unusual body sensations scare me.",:pick=>:one
      q_asi_15 "When I am nervous, I worry that I might be mentally ill.",:pick=>:one
      q_asi_16 "It scares me when I am nervous.",:pick=>:one
    end
  end
end
