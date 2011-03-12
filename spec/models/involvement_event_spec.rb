require 'spec_helper'

describe InvolvementEvent do

  it "should create a new instance given valid attributes" do
    Factory(:involvement_event).should be_valid
  end

  it "should be valid if the event being added on different day" do 
    event = Factory(:event_type)
    involvement = Factory(:involvement)
    a = Factory(:involvement_event, :event_type => event, :occurred_on => "04/10/2010", :involvement => involvement)
    a.should be_valid
    b = Factory.build(:involvement_event, :event_type => event, :occurred_on => "04/11/2010", :involvement => involvement)
    b.should be_valid
  end

  it "should not throw an error when occurred_on is actually a date" do
    event = Factory(:event_type)
    involvement = Factory(:involvement)
    lambda {involvement.involvement_events.create(:event_type => event, :occurred_on => Time.now)}.should_not raise_error
  end

  it "should not be valid if the event being added on the SAME day" do 
    event = Factory(:event_type)
    involvement = Factory(:involvement)
    a = Factory(:involvement_event, :event_type => event, :occurred_on => "04/10/2010", :involvement => involvement)
    a.should be_valid
    b = Factory.build(:involvement_event, :event_type => event, :occurred_on => "04/10/2010", :involvement => involvement)
    b.should_not be_valid
  end
   
  describe "setting event type" do
    before(:each) do 
      @study = Factory(:study)
      @inv = Factory(:involvement, :study => @study)
      @evn = Factory(:involvement_event, :involvement => @inv)
    end

    it "can be set by passing the event name to a custom method" do
      @evn.event = "Consented"
      @evn.event_type.name.should  == "Consented"
      @evn.event_type_id.should == @study.event_types.find_by_name("Consented").id
    end
    
    it "can get the event name using a custom method" do
      @evn.event_type = @study.event_types.find_by_name("Completed")
      @evn.event.should == "Completed"
    end

    it "can be built using rails association calls" do
      pending # this just straight up doesn't work... events cannot be assigned in this way
      @inv.involvement_events.create(:occurred_on => Time.now.to_s, :event => "Consented")
      e = @inv.involvement_events.detect("Consented")
      e.should_not be_nil
    end
  end

  it "should be invalid without a involvement and date or type" do
    a = Factory.build(:involvement_event, :occurred_on => nil, :event_type_id => nil, :involvement_id => nil)
    a.should_not be_valid
    a.should have(1).error_on(:occurred_on)
    a.should have(1).error_on(:event_type_id)
    #a.should have(1).error_on(:involvement_id) #see model. Rails bug exists that prevents this from being enforced

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
    involvement = Factory(:involvement, :study => Factory(:study))
    involvement_id = involvement.id
    event = Factory(:involvement_event, :involvement => involvement)
    event.destroy
    Involvement.find_by_id(involvement_id).should == nil
  end

  it "should not remove parent involvement on destroy if it has siblings" do
    study = Factory(:study)
    involvement = Factory(:involvement, :study => study)
    involvement_id = involvement.id
    event = Factory(:involvement_event, :involvement => involvement, :event_type => study.event_types.find_by_name("Consented"))
    sibling = Factory(:involvement_event, :involvement => involvement, :event_type => study.event_types.find_by_name("Withdrawn"))
    event.destroy
    Involvement.find_by_id(involvement_id).should_not == nil
  end

  it "should let me know how many accruals (unique by involvement) were completed to date" do
    study = Factory(:fake_study)
    InvolvementEvent.count_accruals.should == 0
    ev_type = study.event_types.find_by_name("Consented")

    10.times do |i|
      involvement = Factory.create( :involvement, :study => study, 
                                   :subject => Factory.create(:fake_subject),
                                    :gender => Involvement.genders.rand, 
                                    :ethnicity => Involvement.ethnicities.rand,
                                    :races => Involvement.races.rand)
      Factory.create( :involvement_event, :event_type => ev_type, :occurred_on=>(i+10).days.ago, :involvement => involvement )
    end
    involvement_ids = Involvement.all.map(&:id)
    event_type = study.event_types.first
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

