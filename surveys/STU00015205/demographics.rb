Survey "Demographics"
  
  section "Other Demographic information" do

    q_demo1 "What is your current marital status?", :pick=>"one"
    a_1 "Married, or living as married", :display_order=>1

    a_2 "Widowed", :display_order=>2

    a_3 "Divorced", :display_order=>3

    a_4 "Separated", :display_order=>4

    a_5 "Never married", :display_order=>5


    q_demo2 "What is your highest level of education completed?", :pick=>"one"
    a_1 "Less than high school", :display_order=>1

    a_2 "High School / GED", :display_order=>2

    a_3 "Some College", :display_order=>3

    a_4 "Associate’s Degree", :display_order=>4

    a_5 "College Degree", :display_order=>5

    a_6 "Master’s Degree", :display_order=>6

    a_7 "Graduate Degree (M.D./Ph.D/J.D.)", :display_order=>7


    q_demo3 "What is your annual household income from all sources?", :pick=>"one"
    a_1 "Less than $10,000", :display_order=>1

    a_2 "$10,000 to less than $20,000", :display_order=>2

    a_3 "$20,000 to less than $30,000", :display_order=>3

    a_4 "$30,000 to less than $40,000", :display_order=>4

    a_5 "$40,000 to less than $5,0000", :display_order=>5

    a_6 "$50,000 to less than $60,000", :display_order=>6

    a_7 "$60,000 to less than $70,000", :display_order=>7

    a_8 "$70,000 to less than $80,000", :display_order=>8

    a_9 "$80,000 to less than $90,000", :display_order=>9

    a_10 "$90,000 to less than $100,000", :display_order=>10

    a_11 "$100,000 or higher", :display_order=>11

    a_12 "Not answered", :display_order=>12

  end
end
