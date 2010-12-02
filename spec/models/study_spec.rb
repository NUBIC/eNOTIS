require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Study do

  before(:each) do
    @study = Factory(:study)
    @study.irb_number = "STU0001031"
  end

  it "should not be valid with out an irb_number" do
    @study.irb_number = nil
    @study.valid?.should be_false
    @study.irb_number = "STU0001031"
    @study.valid?.should be_true
  end

  it "returns event definitions given the event name" do
    @study.create_event_type({:name => "foo", :description => "Something which is foo'd"})
    @study.define_event("foo").should == "Something which is foo'd"
  end

  it "returns accrual as the number of consented patients on a study" do
    @study.create_event_type("Consented")
    ev = @study.event_types.find_by_name("consented")
    3.times do
      inv = Factory(:involvement, :study => @study, :subject => Factory(:fake_subject))
      Factory(:involvement_event, :event_type => ev, :involvement => inv)
    end
    @study.accrual.should == 3
  end


  it "should tell us when we can accrue subjects" do
    ["Approved", "Exempt Approved", "Not Under IRB Purview", "Revision Closed", "Revision Open"].each do |status|
      Factory(:study, :irb_status => status).can_accrue?.should be_true
    end
    ["Rejected", "Suspended", "Withdrawn", "foo", nil].each do |status|
      Factory(:study, :irb_status => status).can_accrue?.should be_false
    end
  end

  it "should override the default to_param method" do
    @study.to_param.should == @study.irb_number
  end

  describe "Changes to the edit status of a study" do

    it "can be set to a read only" do
      @study.read_only!
      @study.read_only.should be_true
    end

    it "can have a read only message for the user" do
      @study.read_only!("This study is managed in NOTIS")
      @study.read_only_msg.should == "This study is managed in NOTIS"
    end

    it "can clear the read only status" do
      @study.editable!
      @study.read_only.should be_false
      @study.read_only_msg.should be_nil
    end
  end

 describe "custom study events" do

    it "adds events" do
      base_count = @study.event_types.count
      @study.create_event_type("Surgery 1")
      @study.event_types.first.name.should == "Surgery 1"
      @study.event_types.size.should == base_count + 1
    end

    it "makes sure event names are unique" do
      @study.event_types.delete_all
      @study.event_types.should be_empty
      @study.create_event_type("Drug")
      @study.create_event_type("drug")
      @study.create_event_type("dRUG")
      @study.event_types.count.should == 1
    end

    it "trims event names for whitespace" do
      @study.event_types.delete_all
      @study.event_types.should be_empty
      @study.create_event_type("    DRUG")
      @study.create_event_type("DRUG    ")
      @study.create_event_type("  DRUG   ")
      @study.event_types.count.should == 1
    end

    it "finds an event even if the formatting is off" do
      @study.create_default_events
      s = @study.event_types.find_by_name("cONsented  ")
      s.should_not be_nil
      s.name.should == "Consented"
    end

  end

  describe "default events" do

    before(:each) do 
      @fs = Factory(:study)
    end

    it "creates new defaults for a new study" do
      s = Study.create(:irb_number => "STU01010101")
      s.event_types.should_not be_empty
      s.event_types.should have(EventType::DEFAULT_EVENTS.keys.count).event_types
    end

    it "help with event definition" do
      @fs.define_event("consented").should_not be_empty
      @fs.define_event("CONSENTED").should =~ /informed consent/
      @fs.define_event("Completed").should_not be_empty
      @fs.define_event("ComPLETED").should =~ /completed/
    end

    it "creates all the events from the default event list for a particular study" do
      #@fs.event_types.should be_empty
      #@fs.create_default_events # event creation is triggered after create now -BLC
      @fs.event_types.should_not be_empty
      EventType::DEFAULT_EVENTS.each do |k,v|
        # NOTE: I realized this test would pass if the finder was changed to return :all instead of :first
        # so I added (and tested) this conditional test -BLC
        if @fs.event_types.find_by_name("not_gonna_find_this").respond_to?(:is_empty?) #if the finder returns [] from a find :all
          @fs.event_types.find_by_name(v[:name]).should_not be_empty? "'#{v[:name]}' is not present "
        else # the finder returns nil from a find :first
          @fs.event_types.find_by_name(v[:name]).should_not be_nil "'#{v[:name]}' is not present "
        end
      end
    end

    it "does not create duplicates of the defaults if run twice" do
      @fs.create_default_events
      @fs.event_types.count.should == EventType::DEFAULT_EVENTS.keys.size
      @fs.create_default_events
      @fs.event_types.count.should == EventType::DEFAULT_EVENTS.keys.size
    end

    it "replaces the missing ones if the default events were deleted" do
      @fs.create_default_events
      @fs.event_types.find(:first).delete
      @fs.event_types.count.should == (EventType::DEFAULT_EVENTS.keys.size - 1)
      @fs.create_default_events
      @fs.event_types.count.should == EventType::DEFAULT_EVENTS.keys.size
    end

    it "sets events that are flagged as not editable to not editable" do
      @fs.create_default_events
      e = @fs.event_types.find_by_name("Consented")
      e.editable?.should be_false
    end
    
    it "clobbers edits to the default events should they have been changed" do
      msg = "I have clobbered!!!"
      @fs.create_default_events
      @fs.event_types.each do |et|
        et.description = msg
        et.save
      end
      @fs.event_types.each do |et|
        et.description.should  == msg
      end
      @fs.update_default_events
      @fs.event_types.each do |et|
        et.description.should_not be_nil
        et.description.should_not be_empty
        et.description.should != msg
      end
    end

  end

end
