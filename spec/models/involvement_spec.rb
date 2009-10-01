require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Involvement do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:involvement).should be_valid
  end

  it "does something" do
    # InvolvementEvent.accruals_to_date.should == 0
    # event_type_id = DictionaryTerm.lookup_term("Consented","Event").id
    # gender_type_ids = DictionaryTerm.lookup_category_terms('Gender').map(&:id)
    # ethnicity_type_ids = DictionaryTerm.lookup_category_terms('Ethnicity').map(&:id)
    # 10.times do |i|
    #   involvement = Factory.create( :involvement, :study_id => study_ids.rand, :subject_id => subject_ids.rand,
    #                                 :gender_type_id => gender_type_ids.rand, :ethnicity_type_id => ethnicity_type_ids.rand)
    #   Factory.create( :involvement_event, :event_type_id => event_type_id, :involvement => involvement )
    # end
    # study_ids = Study.all.map(&:id)
    # subject_ids = Subjet.all.map(&:id)
    # involvement = Factory.create( :involvement, :study_id => study_ids.rand, :subject => Factory.create(:fake_subject),
    #                               :gender_type_id => gender_type_ids.rand, :ethnicity_type_id => ethnicity_type_ids.rand)
    # 
    # 5.times do |i|
    #   Factory.create( :involvement_event, :event_type_id => event_type_id, :involvement => Involvement.find(involvement_ids.rand) )
    # end
    # InvolvementEvent.accruals_to_date.should == 10
    # 
  end
  
end
