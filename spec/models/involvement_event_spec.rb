require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvolvementEvent do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    InvolvementEvent.create!(@valid_attributes)
  end

  it "should return all involvement events on a given study" do
    @study = Factory(:fake_study)
    @not_my_study = Factory(:fake_study)
    
    3.times{Factory(:involvement_event, :involvement => Factory(:involvement, :study => @study))}
    3.times{Factory(:involvement_event, :involvement => Factory(:involvement, :study => @not_my_study))}
    InvolvementEvent.on_study(@study).should have(3).involvement_events
  end
  it "should return all involvement events on a given study as x/y values" do
    @study = Factory(:fake_study)
    @not_my_study = Factory(:fake_study)
    
    3.times{Factory(:involvement_event, :involvement => Factory(:involvement, :study => @study))}
    3.times{Factory(:involvement_event, :involvement => Factory(:involvement, :study => @not_my_study))}
    InvolvementEvent.on_study(@study).to_graph.last[1].should == 3
  end
  it "should remove parent invovlement on destroy if it has no siblings" do
    involvement = Factory(:involvement)
    involvement_id = involvement.id
    event = Factory(:involvement_event, :involvement => involvement)
    event.destroy
    Involvement.find_by_id(involvement_id).should == nil
  end
  it "should not remove parent invovlement on destroy if it has siblings" do
    involvement = Factory(:involvement)
    involvement_id = involvement.id
    event = Factory(:involvement_event, :involvement => involvement)
    sibling = Factory(:involvement_event, :involvement => involvement)
    event.destroy
    Involvement.find_by_id(involvement_id).should_not == nil
  end
  
  it "should let me know how many accruals (unique by involvement) were completed to date" do
    InvolvementEvent.count_accruals.should == 0
    event_type_id = DictionaryTerm.lookup_term("Consented","Event").id
    gender_type_ids = DictionaryTerm.lookup_category_terms('Gender').map(&:id)
    ethnicity_type_ids = DictionaryTerm.lookup_category_terms('Ethnicity').map(&:id)
    10.times do |i|
      involvement = Factory.create( :involvement, :study => Factory.create(:fake_study), :subject => Factory.create(:fake_subject),
                                    :gender_type_id => gender_type_ids.rand, :ethnicity_type_id => ethnicity_type_ids.rand)
      Factory.create( :involvement_event, :event_type_id => event_type_id,:occurred_on=>(i+10).days.ago,:involvement => involvement )
    end
    involvement_ids = Involvement.all.map(&:id)
    5.times do |i|
      Factory.create( :involvement_event, :event_type_id => event_type_id,:occurred_on=> i.days.ago, 
                     :involvement => Involvement.find(involvement_ids.rand) )
    end
    InvolvementEvent.count_accruals.should == 10
  end
  
end
