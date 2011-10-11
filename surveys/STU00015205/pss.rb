survey "Perceived Stress Scale" ,:irb_number=>'STU00015205',:score_configurations_attributes=>[{:name=>'Perceived Stress Scale',:algorithm=>'total_sum'}] do 
  section "main" do

    group "The questions in this scale ask you about your feelings and thoughts DURING THE LAST MONTH. In each case, you will be asked to indicate how often you felt or thought a certain way by blackening the appropriate circle.",:display_type=>"manual_grid" do


      q_pss_1 "In the last month, how often have you felt that you were unable to control the important things in your life?",:pick=>:one,:score_code=>"forward"
      a_1 "Never",:weight=>0
      a_2 "Almost Never",:weight=>1
      a_3 "Sometimes",:weight=>2
      a_4 "Fairly Often",:weight=>3
      a_5 "Very Often",:weight=>4
      q_pss_2 "In the last month, how often have you felt confident about your ability to handle your personal problems?",:pick=>:one,:score_code=>"reverse"
      a_1 "Never",:weight=>4
      a_2 "Almost Never",:weight=>3
      a_3 "Sometimes",:weight=>2
      a_4 "Fairly Often",:weight=>1
      a_5 "Very Often",:weight=>0
      q_pss_3 "In the last month, how often have you felt that things were going your way?",:pick=>:one,:score_code=>"reverse"
      a_1 "Never",:weight=>4
      a_2 "Almost Never",:weight=>3
      a_3 "Sometimes",:weight=>2
      a_4 "Fairly Often",:weight=>1
      a_5 "Very Often",:weight=>0
      q_pss_4 "In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?",:pick=>:one,:score_code=>"forward"
      a_1 "Never",:weight=>0
      a_2 "Almost Never",:weight=>1
      a_3 "Sometimes",:weight=>2
      a_4 "Fairly Often",:weight=>3
      a_5 "Very Often",:weight=>4
    end
  end
end
