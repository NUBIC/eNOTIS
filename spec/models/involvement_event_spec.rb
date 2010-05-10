require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvolvementEvent do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:involvement_event).should be_valid
  end
  
  it "should be invalid if not unique on involvement, event, date" do
    event = "Consented"
    occurred_on = "2010-04-19"
    involvement = Factory(:involvement)
    a = Factory(:involvement_event, :event => event, :occurred_on => occurred_on, :involvement => involvement)
    a.should be_valid
    b = Factory.build(:involvement_event, :event => event, :occurred_on => occurred_on, :involvement => involvement)
    b.should_not be_valid
  end
  it "should be invalid without a involvement and date" do
    a = Factory.build(:involvement_event, :occurred_on => nil)
    a.should_not be_valid
    a.should have(1).error_on(:occurred_on)
    b = Factory.build(:involvement_event, :involvement_id => nil)
    b.should_not be_valid
    b.should have(1).error_on(:involvement_id)
  end
  it "should accept events (case insensitive) and set the right case" do
    InvolvementEvent.new(:event => "cOnSeNtEd").event.should == "Consented"
    InvolvementEvent.new(:event => "completed").event.should == "Completed"
    InvolvementEvent.new(:event => "WITHDRAWN").event.should == "Withdrawn"
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
  it "should remove parent involvement on destroy if it has no siblings" do
    involvement = Factory(:involvement)
    involvement_id = involvement.id
    event = Factory(:involvement_event, :involvement => involvement)
    event.destroy
    Involvement.find_by_id(involvement_id).should == nil
  end
  it "should not remove parent involvement on destroy if it has siblings" do
    involvement = Factory(:involvement)
    involvement_id = involvement.id
    # Added :event => "Consented", and :event => "Widthdrawn" to prevent duplicate key errors in test
    # the index:
    #   ["involvement_id", "event", "occurred_on"], :name => "inv_events_attr_idx", :unique => true
    # is violated when two factory generated involvement events have the same date and event
    # this happens quite often. Since there are 3 events, and two possible days, the probability is 1/6.  
    event = Factory(:involvement_event, :involvement => involvement, :event => "Consented")
    sibling = Factory(:involvement_event, :involvement => involvement, :event => "Withdrawn")
    event.destroy
    Involvement.find_by_id(involvement_id).should_not == nil
  end
  
  it "should let me know how many accruals (unique by involvement) were completed to date" do
    InvolvementEvent.count_accruals.should == 0
    10.times do |i|
      involvement = Factory.create( :involvement, :study => Factory.create(:fake_study), :subject => Factory.create(:fake_subject),
                                    :gender => Involvement.genders.rand, :ethnicity => Involvement.ethnicities.rand, :race => Involvement.races.rand)
      Factory.create( :involvement_event, :event => "Consented",:occurred_on=>(i+10).days.ago,:involvement => involvement )
    end
    involvement_ids = Involvement.all.map(&:id)
    5.times do |i|
      Factory.create( :involvement_event, :event => "Consented",:occurred_on=> i.days.ago, 
                     :involvement => Involvement.find(involvement_ids.rand) )
    end
    InvolvementEvent.count_accruals.should == 10
  end
  
end
