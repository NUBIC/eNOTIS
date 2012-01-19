survey "Impedence",:irb_number=>"STU00015205",:active_at=>Time.now,:inactive_at=>nil do
  
  section "Main" do 
    question_1 "INITIALS"
      a :string
  question_2 "pH-mil #"
  a :string
  question_3 "Date of Procedure"
  a :date
  q_4 "Baseline-0/ FU - month"
  a :string
  q_5 "MED BEFORE TEST- PREVIOUS 4 WEEKS"
    a :string

  q_6 "TEST- OFF/ON",:pick=>:one
    a_0 "Off 7-10 days"
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
    a_7 "other"

  q_9 "% IMPROVE OF HB/CP"
   a :string
  q_10 "% IMPROVE OF 1-SYMPT"
   a :string

  q_11 "U-%TIME Ph<4"
   a :string
  q_12 "S-%TIME Ph<5"
   a :string

  q_13 "T-%TIME Ph<6"
   a :string

  q_14 "ACID RE"
   a :string

  q_15 "WA RE"
   a :string

  q_16 "ALK RE"
   a :string

  q_17 "TOTAL RE"
   a :string

  q_18 "TOTAL SYMP"
   a :string
  q_19 "SI ACID ONLY"
   a :string
  q_20 "SI ALL REFLUX"
   a :string
  q_21 "SAP ACID ONLY"
   a :string
  q_22 "SAP ALL REFLUX"
   a :string

  q_23 "Impedance Phenotype",:pick=>:one

    a_1 "persistent acid"
    a_2 "hypersensitive"
    a_3 "functional overlap"
    a_4 "Functional heartburn"

  end

end
