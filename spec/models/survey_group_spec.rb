require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveyGroup do
 
 before(:each) do
   @response = Factory.create(:response)
   @response_set = @response.response_set
   
   @first_survey = @response_set.survey
   @first_survey.update_attribute(:display_order, 1)
   
   @second_survey = Factory.create(:survey)
   @second_survey.update_attributes({:survey_group => @survey_group, :display_order => 2})
   
   @survey_group = @first_survey.survey_group
 end
 
 it "should return the next survey in a group when 'next' is called" do
   next_sequential_response_set = @survey_group.next(@response_set)
   
   next_sequential_response_set.class.should be ResponseSet.class
   next_sequential_response_set.should_not be nil
 end
 
 it "should, if the progression is sequential, give the surveys in the correct order, given subsequent calls to 'next' when the current survey is completed"
 
 it "should prevent you from moving to another survey within the group, if the current survey is not yet complete"
 
 it "random progression should actually be somewhat random"
 
 it "random progression cannot return the current survey from the next method"
 
 it "should ignore forms that are inactive"
 
end
