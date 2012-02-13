survey "GI Diaries", :irb_number=>"STU00039540" do
  section "Diary" do
    repeater "Morning" do
      q_morning_symptoms "What symptoms did you have last night?", :pick => :one
      a "none"
      a "heartburn"
      a "regurgitation"
      a "both"
    
      q_morning_severity "How severe were your symptoms?", :pick => :one
      a "mild"
      a "moderate"
      a "severe"
    
      q_morning_sleep "Did symptoms interfere with your sleep?", :pick => :one
      a "yes"
      a "no"
    
      q_morning_antacids "How many times did you take antacids?"
      a :integer
    end
    repeater "Evening" do
      q_evening_symptoms "What symptoms did you have last night?", :pick => :one
      a "none"
      a "heartburn"
      a "regurgitation"
      a "both"
    
      q_evening_severity "How severe were your symptoms?", :pick => :one
      a "mild"
      a "moderate"
      a "severe"

      q_evening_antacids "How many times did you take antacids?"
      a :integer
    end
  end
end