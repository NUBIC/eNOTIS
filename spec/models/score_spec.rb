require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Score do
  
  it "should consider scores with the same score_configuration_id and response_set_id to be invalid, regardless of the value of the score itself" do
    # The two start identically
    first_score   = Score.create(:score_configuration_id => 1, :response_set_id => 1, :value => 100)
    second_score  =    Score.new(:score_configuration_id => 1, :response_set_id => 1, :value => 100)
    second_score.valid?.should be_false
    
    # Change just score_configuration_id
    second_score.score_configuration_id = 2
    second_score.valid?.should be_true
    
    second_score.score_configuration_id = 1
    second_score.valid?.should be_false
    
    # Change just response_set_id
    second_score.response_set_id = 2
    second_score.valid?.should be_true
    
    second_score.response_set_id = 1
    second_score.valid?.should be_false
  end
  
end
