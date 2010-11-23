require 'spec_helper'

describe InvolvementEvent do

  it "should create a new instance given valid attributes" do
    Factory(:involvement_event).should be_valid
  end

  it "should be valid if the event being added is repeatable" do 
    event = Factory(:event_type)
    occurred_on = "04/10/2010"
    involvement = Factory(:involvement)
    a = Factory(:involvement_event, :event_type => event, :occurred_on => occurred_on, :involvement => involvement)
    a.should be_valid
    b = Factory.build(:involvement_event, :event_type => event, :occurred_on => occurred_on, :involvement => involvement)
    b.should be_valid

  end

  it "should be invalid without a involvement and date" do
    a = Factory.build(:involvement_event, :occurred_on => nil)
    a.should_not be_valid
    a.should have(1).error_on(:occurred_on)
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
    study = Factory(:fake_study)
    study.create_default_events
    InvolvementEvent.count_accruals.should == 0
    event_type = study.event_types.find_by_name("Consented")

    10.times do |i|
      involvement = Factory.create( :involvement, :study => study, 
                                   :subject => Factory.create(:fake_subject),
                                    :gender => Involvement.genders.rand, 
                                    :ethnicity => Involvement.ethnicities.rand,
                                    :races => Involvement.races.rand)
      Factory.create( :involvement_event, :event_type => event_type, :occurred_on=>(i+10).days.ago, :involvement => involvement )
    end
    involvement_ids = Involvement.all.map(&:id)
    event_type = Factory(:event_type)
    5.times do |i|
      Factory.create( :involvement_event, :event_type => event_type ,:occurred_on=> i.days.ago, 
                     :involvement => Involvement.find(involvement_ids.rand) )
    end
    InvolvementEvent.count_accruals.should == 10
  end
  
 describe "class methods" do

    it "should let me know how many accruals were completed to date" do
       
       InvolvementEvent.accruals.count.should == 0
       10.times do |i|
         study = Factory(:fake_study)
         study.create_default_events
         et = study.event_types.find_by_name("Consented")
         involvement = Factory.create( :involvement, :study => study,
                                       :subject => Factory.create(:fake_subject),
                                       :gender => Involvement.genders.rand,
                                       :ethnicity => Involvement.ethnicities.rand,
                                       :races => Involvement.races.rand)
         Factory(:involvement_event, :event_type => et, :occurred_on=>(i+10).days.ago, :involvement => involvement)
       end
       InvolvementEvent.accruals.count.should == 10
    end
  end
 
end

