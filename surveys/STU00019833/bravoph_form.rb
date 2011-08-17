survey "esophageal - Bravo pH monitoring",:irb_number=>"STU00019833",:category=>"PRO" do

  section "Day 2" do 
    q_daytwo_1 "Test performed on or off medication?", :pick=>:one
      a_1 "Off medication"
      a_2 "On medication"

    repeater "Medication regimen (PPI)" do    
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

end
