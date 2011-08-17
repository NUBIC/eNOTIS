survey "Orientation Screener for Participants",:irb_number=>"STU00017350",:score_configurations_attributes=>[{:name=>'PHQ-9',:algorithm=>'phq'},{:name=>'ADHD',:algorithm=>"adhd"}] do
  section "PHQ-9" do
    label "Over the last 2 weeks, how often have you been bothered by any of the following problems?"
      
    q_1 "Little interest or pleasure in doing things", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "0"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
    
    q_2 "Feeling down, depressed, or hopeless", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "0"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
        
    q_3 "Trouble falling or staying asleep, or sleeping too much", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "0"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
        
    q_4 "Feeling tired or having little energy", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "0"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
        
    q_5 "Poor appetite or overeating", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "0"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
    
    q_6 "Feeling bad about yourself - or that you are a failure or have let yourself or your family down", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "0"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
    
    q_7 "Trouble concentrating on things, such as reading the newspaper or watching television", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "0"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
    
    q_8 "Moving or speaking so slowly that other people could have noticed. Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "0"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
    
    q_9 "Thoughts that you would be better off dead, or of huting yourself in some way", :pick => :one,:score_code=>'phq'
    a_not_at_all "Not at all", :weight => "0"
    a_several_days "Several days", :weight => "1"
    a_more_than_half_the_day "More than half the days", :weight => "1"
    a_nearly_every_day "Nearly every day", :weight => "1"
    
    q_how_difficult "If you checkd off <i>any</i> problems, how <i>difficult</i> have these problems made it for you to do our work, take care of things at home, or get along with other people?", :pick => :one,:score_code=>'phq'
    a_not_difficult_at_all "Not difficult at all"
    a_somewhat_difficult "Somewhat difficult"
    a_very_difficult "Very difficult"
    a_extremely_difficult "Extremely difficult"
    
  end
  section "AS" do
    label "Please answer the questions below, rating yourself on each of the criteria shown using the scale on the right side of the page. 
       As you answer each question, select the box that best describes how you have felt and conducted yourself over the past 6 months. Please 
       give this completed checklist to your healthcare professional to discuss during today's appointment"
         
      
     q_1 "How often do you have trouble wrapping up the final details of thep roject, once the challenging parts have been done?", :pick => :one,:score_code=>'adhd'
     a_never "Never", :weight => "0"
     a_rarely "Rarely", :weight => "0"
     a_sometimes "Sometimes", :weight => "1"
     a_often "Often", :weight => "1"
     a_very_often "Very Often", :weight => "1"
     
     q_2 "How often do you have difficulty getting things in order when you have to do a task that requires organization?", :pick => :one,:score_code=>'adhd'
     a_never "Never", :weight => "0"
     a_rarely "Rarely", :weight => "0"
     a_sometimes "Sometimes", :weight => "1"
     a_often "Often", :weight => "1"
     a_very_often "Very Often", :weight => "1"
          
     q_3 "How often do you have problems remembering appointments or obligations?", :pick => :one,:score_code=>'adhd'
     a_never "Never", :weight => "0"
     a_rarely "Rarely", :weight => "0"
     a_sometimes "Sometimes", :weight => "1"
     a_often "Often", :weight => "1"
     a_very_often "Very Often", :weight => "1"
     
     q_4 "When you have a task that requires a lot of thought, how often do you avoid or delay getting started?", :pick => :one,:score_code=>'adhd'
     a_never "Never", :weight => "0"
     a_rarely "Rarely", :weight => "0"
     a_sometimes "Sometimes", :weight => "0"
     a_often "Often", :weight => "1"
     a_very_often "Very Often", :weight => "1"
     
     q_5 "How often do you fidget or squirm with your hands or feet when you have to sit down for a long time?", :pick => :one,:score_code=>'adhd'
     a_never "Never", :weight => "0"
     a_rarely "Rarely", :weight => "0"
     a_sometimes "Sometimes", :weight => "0"
     a_often "Often", :weight => "1"
     a_very_often "Very Often", :weight => "1"
     
     q_6 "How often do you feel overly active and compelled to do things, like you were driven by a motor?", :pick => :one,:score_code=>'adhd'
     a_never "Never", :weight => "0"
     a_rarely "Rarely", :weight => "0"
     a_sometimes "Sometimes", :weight => "0"
     a_often "Often", :weight => "1"
     a_very_often "Very Often", :weight => "1"
  end
end    
