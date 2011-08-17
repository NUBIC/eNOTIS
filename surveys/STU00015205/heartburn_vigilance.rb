survey "Heartburn Vigilance and Awareness Scale" ,:irb_number=>'STU00015205',:score_configurations_attributes=>[{:name=>'Heart Vigilance and Awareness Scale',:algorithm=>'total_sum'},{:name=>'Attention to Pain',:algorithm=>'partial_sum',:question_code=>'pain'},{:name=>"Attention to change in pain",:algorithm=>'partial_sum',:question_code=>'pain_delta'}] do 
  section "main" do

    group "Please rate on the following scale how often the statements below are true for you.",:display_type=>"manual_grid" do


      q_hvas_1 "I am very sensitive to heartburn.",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_2 "I am aware of sudden or temporary changes in heartburn.",:pick=>:one,:score_code=>"pain_delta"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_3 "I am quick to notice changes in heartburn intensity.",:pick=>:one,:score_code=>"pain_delta"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_4 "I am quick to notice effects of medication on heartburn.",:pick=>:one,:score_code=>"pain_delta"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_5 "I am quick to notice changes in location or extent of heartburn.",:pick=>:one,:score_code=>"pain_delta"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_6 "I focus on sensations of heartburn.",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_7 "I notice heartburn even if I am busy with another activity.",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_8 "I find it easy to ignore heartburn",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>5
        a_2 "Rarely",:weight=>4
        a_3 "Sometimes",:weight=>3
        a_4 "Often",:weight=>2
        a_5 "Very Often",:weight=>1
        a_6 "Always",:weight=>0
      q_hvas_9 "I know immediately when heartburn starts or increases.",:pick=>:one,:score_code=>"pain_delta"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_10 "When I do something that increases heartburn, the first thing I do is check to see how much heartburn was increased",:pick=>:one,:score_code=>"pain_delta"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_11 "I know immediately when heartburn decreases.",:pick=>:one,:score_code=>"pain_delta"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_12 "I seem to be more conscious of heartburn than others.",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_13 "I pay close attention to heartburn.",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_14 "I keep track of my heartburn level.",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_15 "I become preoccupied with heartburn.",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>0
        a_2 "Rarely",:weight=>1
        a_3 "Sometimes",:weight=>2
        a_4 "Often",:weight=>3
        a_5 "Very Often",:weight=>4
        a_6 "Always",:weight=>5
      q_hvas_16 "I do not dwell on heartburn.",:pick=>:one,:score_code=>"pain"
        a_1 "Never",:weight=>5
        a_2 "Rarely",:weight=>4
        a_3 "Sometimes",:weight=>3
        a_4 "Often",:weight=>2
        a_5 "Very Often",:weight=>1
        a_6 "Always",:weight=>0
    end
  end
end
