survey "Bravo pH",:irb_number=>"STU00015205",:active_at=>Time.now,:inactive_at=>nil do
  
  section "Main" do 
  question_1 "INITIAL"
  a :string
  question_2 "Bravo #"
  a :string
  question_3 "Date of Procedure"
  a :date
  q_4 "Baseline-0/ FU - month"
  a :string
  q_5 "MED BEFORE TEST- PREVIOUS 4 WEEKS",:pick=>:one
   a_0 "None"
   a_1 "Single Dose PPI"
   a_2 "Double Dose PPI"
   a_3 "> Double Dose PPI"
   a_4 "Hoarseness/sore throat/throat burning"
   a_5 "Cough"
   a_6 "GLobus"
   a_7 "Other"

  

  q_6 "TEST- OFF/ON",:pick=>:one
    a_0 "Off"
    a_1 "On Single"
    a_2 "On Double"

  q_7 "Indication-physician",:pick=>:one
    a_1 "heartburn"
    a_2 "regurgitation"
    a_3 "chest pain"
    a_4 "hoarseness/sore throat/throat burning"
    a_5 "cough" 
    a_6 "globus"
    a_7 "other"

  q_8 "Pt primary complaint",:pick=>:one
    a_1 "heartburn"
    a_2 "regurgitation"
    a_3 "chest pain"
    a_4 "hoarseness/sore throat/throat burning"
    a_5 "cough" 
    a_6 "globus"
    a_77 "other"

  q_9 "% IMPROVE OF HB/CP"
   a :string

  q_10 "% IMPROVE OF 1-SYMPT"
   a :string

  q_11 "RECORDING TIME"
   a :string
  q_12 "NUMBER OF DAYS-ADEQ"
   a :string

  q_13 "D1-U-%TIME Ph<4"
   a :string
  q_14 "D1-S-%TIME Ph<4"
   a :string

  q_15 "D1-T-%TIME Ph<4"
   a :string
  q_16 "D1-TOTAL RE"
   a :string
  q_17 "D1-TOTAL SYMP"
   a :string
  q_18 "D1-SI ACID ONLY"
   a :string
  q_20 "D1-SAP ACID ONLY"
   a :string

  q_21 "D2-U-%TIME Ph<4"
   a :string

  q_22 "D2-S-%TIME Ph<4"
   a :string
  q_23 "D2-T-%TIME Ph<4"
   a :string
  q_24 "D2-TOTAL RE"
   a :string
  q_25 "D2-TOTAL SYMP"
   a :string
  q_26 "D2-SI ACID ONLY"
   a :string
  q_27 "D2-SAP ACID ONLY"
   a :string
  q_28 "D3-U-%TIME Ph<4"
   a :string
  q_29 "D3-S-%TIME Ph<4"
   a :string
  q_30 "D3-T-%TIME Ph<4"
   a :string

  q_31 "D3-TOTAL RE"
   a :string
  q_32 "D3-TOTAL SYMP"
   a :string
  q_33 "D3-SI ACID ONLY"
   a :string
  
  q_34 "D3-SAP ACID ONLY"
   a :string
  q_35 "D4-U-%TIME Ph<4"
   a :string
  q_36 "D4-S-%TIME Ph<4"
   a :string
  q_38 "D4-T-%TIME Ph<4"
   a :string
  q_39 "D4-TOTAL RE"
   a :string
  q_40 "D4-TOTAL SYMP"
   a :string
  q_41 "D4-SI ACID ONLY"
   a :string
  q_42 "D4-SAP ACID ONLY"
   a :string
  q_43 "Impedance Phenotype",:pick=>:one
    a_1 "Acid reflux disease (> 2 days)"
    a_2 "hypersensitive"
    a_3 "intermittent GER-1 day positive"
    a_4 "Functional heartburn (4 days neg)"

  end


end
