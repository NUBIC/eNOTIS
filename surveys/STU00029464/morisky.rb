survey "Modified Morisky Scale" ,:irb_number=> "STU00029464" do
  
  section "Modified Morisky Scale" do 
    q_ec_mms1 "Do you ever forget to take your medicine?", :pick => :one
      a_0 "Yes"
      a_1 "No"

    q_ec_mms2 "Are you careless at times about taking your medicine?",:pick=>:one
      a_0 "Yes"
      a_1 "No"

    q_ec_mms3 "When you feel better do you sometimes stop taking your medicine?",:pick=>:one
      a_0 "Yes"
      a_1 "No"


    q_ec_mms4 "Sometimes if you feel worse when you take your medicine, do you stop taking it?",:pick=>:one
      a_0 "Yes"
      a_1 "No"


    q_ec_mms5 "Do you know the long-term benefit of taking your medicine as told to you by your doctor or pharmacist?",:pick=>:one
      a_1 "Yes"
      a_0 "No"


    q_ec_mms6 "Sometimes do you forget to refill your prescription medicine on time?",:pick=>:one
      a_0 "Yes"
      a_1 "No"
  end
end
