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
  
  it "should know how many surveys have not been answered in a group, given a ResponseSet object" do
    @survey_group.surveys.count.should be 2
    @survey_group.active_unanswered_surveys(@response_set.involvement).count.should be 1
    
    third_survey = Factory.create(:survey)
    third_survey.update_attributes({:survey_group => @survey_group, :display_order => 3, :active_at => Time.now-5.minutes, :inactive_at => nil})
    
    @survey_group.reload
    @survey_group.surveys.count.should be 3
    @survey_group.active_unanswered_surveys(@response_set.involvement).count.should be 2
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
  
  it "should ignore inactive surveys in SurveyGroups with random progression" do
    @survey_group.update_attribute(:progression, 'random')
    @second_survey.update_attributes({:active_at => nil, :inactive_at => Time.now-5.minutes})

    next_response_set = @survey_group.next(@response_set)
    next_response_set.should be nil
  end
 
  it "random progression cannot return the current survey from the next method" do
    @survey_group.update_attribute(:progression, "random")
    
    100.times do
      next_response_set = @survey_group.next(@response_set)
      unless next_response_set.nil?
        next_response_set.survey.id.should_not be @first_survey.id
      end
    end
  end
 
end
