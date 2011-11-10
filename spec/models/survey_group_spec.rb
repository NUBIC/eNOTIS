require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveyGroup do
 
  before(:each) do
    @response = Factory.create(:response)
    @response_set = @response.response_set
   
    @first_survey = @response_set.survey
    @first_survey.update_attributes({:display_order => 1, :active_at => Time.now-5.minutes, :inactive_at => nil})
   
    @survey_group = @first_survey.survey_group
   
    @second_survey = Factory.create(:survey)
    @second_survey.update_attributes({:survey_group => @survey_group, :display_order => 2, :active_at => Time.now-5.minutes, :inactive_at => nil})
  end
 
  it "should give you the next sequential survey in a group" do
    next_response_set = @survey_group.next(@response_set)
   
    next_response_set.should_not be nil
    next_response_set.should_not be @response_set
  end
 
  it "should give you nil when there are no unanswered surveys left in a sequential SurveyGroup" do
    second_response_set = @survey_group.next(@response_set)
    third_response_set = @survey_group.next(second_response_set)
   
    second_response_set.should_not be nil
    third_response_set.should be nil
  end
 
  it "should give sequential surveys in the correct order" do
    next_response_set = @survey_group.next(@response_set)
   
    next_response_set.survey.id.should be @second_survey.id
  end
 
  it "should ignore sequential forms that are inactive" do
    @second_survey.update_attributes({:active_at => nil, :inactive_at => Time.now-5.minutes})

    next_response_set = @survey_group.next(@response_set)
    next_response_set.should be nil
  end
  
  it "should give you nil when there are no unanswered surveys left in a random SurveyGroup" do
    @survey_group.update_attribute(:progression, "random")
    second_response_set = @survey_group.next(@response_set)
    third_response_set = @survey_group.next(second_response_set)
   
    second_response_set.should_not be nil
    third_response_set.should be nil
  end
  
  it "random survey progression should actually be random" do
    @survey_group.update_attribute(:progression, "random")
    third_survey = Factory.create(:survey)
    third_survey.update_attributes({:survey_group => @survey_group, :display_order => 3, :active_at => Time.now-5.minutes, :inactive_at => nil})
    
    first_survey_count = 0
    second_survey_count = 0
    third_survey_count = 0
    100.times do
      next_response_set = @survey_group.next(@response_set)
      
      if next_response_set.survey.id == @first_survey.id
        first_survey_count += 1
      elsif next_response_set.survey.id == @second_survey.id
        second_survey_count += 1
      elsif next_response_set.survey.id == third_survey.id
        third_survey_count += 1
      end
    end
    
    first_survey_count.should be 0
    second_survey_count.should be > 1
    third_survey_count.should be > 1
    (first_survey_count+second_survey_count+third_survey_count).shoud be 100
  end
  
  it "should ignore random surveys that are inactive"
 
  it "random progression cannot return the current survey from the next method" do
    @survey_group.update_attribute(:progression, "random")
    
    100.times do
      next_response_set = @survey_group.next(@response_set)
      next_response_set.survey.id.should_not be @first_survey.id
    end
  end
 
end
