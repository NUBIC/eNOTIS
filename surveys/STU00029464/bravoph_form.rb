survey "Bravo pH monitoring",:irb_number=>"STU00029464" do
  
  section "Study Date" do 
    q_bravo_date "Date of Bravo pH study"
      a :date, :custom_class => 'date'
  end

  section "Day 1" do 
    q_dayone_1 "Test performed on or off medication?", :pick=>:one
      a_1 "Off medication"
      a_2 "On medication"

    repeater "Medication regimen (PPI)" do    
      dependency :rule => "A"
      condition_A :q_dayone_1, "==", :a_2
        q_dayone_2 "Medication", :pick=> :one, :display_type => :dropdown
          a_0 "None"
          a_1 "Dexlansoprazole (Kapidex)"
          a_2 "Esomeprazole (Nexium)"
          a_3 "Lansoprazole (Prevacid)"
          a_4 "Omeprazole (Prilosec)"
          a_5 "Omeprazole, Sodium Bicarbonate (Zegerid)"
          a_6 "Pantoprazole (Protonix)"
          a_7 "Rabeprazole (Aciphex)"
          a_8 "Other", :string

        q_dayone_3 "Dose (mg)"
          a :string
        q_dayone_4 "Frequency", :pick => :one, :display_type => :dropdown
          a_1 "Daily (AM)"
          a_2  "Daily (PM)"
          a_3 "Twice daily"
    end

    q_dayone_5 "Total # of reflux episodes"
      a_1 :integer

    q_dayone_6 "No. of reflux episodes >5 minutes"
      a_1 :integer

    q_dayone_7 "Longest reflux episode (min)"
      a_1 :integer

    q_dayone_8 "Total time pH<4 (min)"
      a_1 :integer

    q_dayone_9 "% time pH<4"
      a_1 :integer
  end


  section "Day 2" do 
    q_daytwo_1 "Test performed on or off medication?", :pick=>:one
      a_1 "Off medication"
      a_2 "On medication"

    repeater "Medication regimen (PPI)" do    
      dependency :rule => "A"
      condition_A :q_daytwo_1, "==", :a_2
        q_daytwo_2 "Medication", :pick=> :one, :display_type => :dropdown
          a_0 "None"
          a_1 "Dexlansoprazole (Kapidex)"
          a_2 "Esomeprazole (Nexium)"
          a_3 "Lansoprazole (Prevacid)"
          a_4 "Omeprazole (Prilosec)"
          a_5 "Omeprazole, Sodium Bicarbonate (Zegerid)"
          a_6 "Pantoprazole (Protonix)"
          a_7 "Rabeprazole (Aciphex)"
          a_8 "Other", :string

        q_daytwo_3 "Dose (mg)"
          a :string
        q_daytwo_4 "Frequency", :pick => :one, :display_type => :dropdown
          a_1 "Daily (AM)"
          a_2  "Daily (PM)"
          a_3 "Twice daily"
    end
    q_daytwo_5 "Total # of reflux episodes"
      a_1 :integer

    q_daytwo_6 "No. of reflux episodes >5 minutes"
      a_1 :integer

    q_daytwo_7 "Longest reflux episode (min)"
      a_1 :integer

    q_daytwo_8 "Total time pH<4 (min)"
      a_1 :integer

    q_daytwo_9 "% time pH<4"
      a_1 :integer
  end

  section "Day 3" do 
    q_daythree_1 "Test performed on or off medication?", :pick=>:one
      a_1 "Off medication"
      a_2 "On medication"

    repeater "Medication regimen (PPI)" do    
      dependency :rule => "A"
      condition_A :q_daythree_1, "==", :a_2
        q_daythree_2 "Medication", :pick=> :one, :display_type => :dropdown
          a_0 "None"
          a_1 "Dexlansoprazole (Kapidex)"
          a_2 "Esomeprazole (Nexium)"
          a_3 "Lansoprazole (Prevacid)"
          a_4 "Omeprazole (Prilosec)"
          a_5 "Omeprazole, Sodium Bicarbonate (Zegerid)"
          a_6 "Pantoprazole (Protonix)"
          a_7 "Rabeprazole (Aciphex)"
          a_8 "Other", :string

        q_daythree_3 "Dose (mg)"
          a :string
        q_daythree_4 "Frequency", :pick => :one, :display_type => :dropdown
          a_1 "Daily (AM)"
          a_2  "Daily (PM)"
          a_3 "Twice daily"
    end
    q_daythree_5 "Total # of reflux episodes"
      a_1 :integer

    q_daythree_6 "No. of reflux episodes >5 minutes"
      a_1 :integer

    q_daythree_7 "Longest reflux episode (min)"
      a_1 :integer

    q_daythree_8 "Total time pH<4 (min)"
      a_1 :integer

    q_daythree_9 "% time pH<4"
      a_1 :integer
  end

  section "Day 4" do 
    q_dayfour_1 "Test performed on or off medication?", :pick=>:one
      a_1 "Off medication"
      a_2 "On medication"

    repeater "Medication regimen (PPI)" do    
      dependency :rule => "A"
      condition_A :q_dayfour_1, "==", :a_2
        q_dayfour_2 "Medication", :pick=> :one, :display_type => :dropdown
          a_0 "None"
          a_1 "Dexlansoprazole (Kapidex)"
          a_2 "Esomeprazole (Nexium)"
          a_3 "Lansoprazole (Prevacid)"
          a_4 "Omeprazole (Prilosec)"
          a_5 "Omeprazole, Sodium Bicarbonate (Zegerid)"
          a_6 "Pantoprazole (Protonix)"
          a_7 "Rabeprazole (Aciphex)"
          a_8 "Other", :string

        q_dayfour_3 "Dose (mg)"
          a :string
        q_dayfour_4 "Frequency", :pick => :one, :display_type => :dropdown
          a_1 "Daily (AM)"
          a_2  "Daily (PM)"
          a_3 "Twice daily"
    end
    q_dayfour_5 "Total # of reflux episodes"
      a_1 :integer

    q_dayfour_6 "No. of reflux episodes >5 minutes"
      a_1 :integer

    q_dayfour_7 "Longest reflux episode (min)"
      a_1 :integer

    q_dayfour_8 "Total time pH<4 (min)"
      a_1 :integer

    q_dayfour_9 "% time pH<4"
      a_1 :integer
  end

  section "Symptom Index" do

   q_bravo_si_1 "Symptom Index, Day 1"
    a_1 :string

   q_bravo_si_2 "Symptom Index, Day 2"
    a_1 :string

   q_bravo_si_3 "Symptom Index, Day 3"
    a_1 :string

   q_bravo_si_4 "Symptom Index, Day 4"
    a_1 :string
  end

  section "Comments" do
     q_bravo_comments "Comments"
       a_1 :text

  end

end
