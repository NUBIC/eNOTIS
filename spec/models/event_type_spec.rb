require 'spec_helper'

describe EventType do

  describe "Class methods" do
    
    it "formats the event name the way we would like" do
      #also, no harm to the string
      b_str = "  PRE-SCREENED    Test1 "
      EventType.event_name_formatter(b_str).should == "Pre-screened Test1"
      b_str.should == "  PRE-SCREENED    Test1 "
      # and some other easier ones
      EventType.event_name_formatter(" Drug TEST").should == "Drug Test"
      EventType.event_name_formatter("CONSENTED").should == "Consented"
      EventType.event_name_formatter("complete").should == "Complete"
      EventType.event_name_formatter("failed   screen ").should == "Failed Screen"
    end

  end

  describe "Instance methods" do

    it "has a valid factory" do
      Factory(:event_type).should be_valid
    end
   
    it "knows if it's editable" do
      e = Factory(:event_type, :editable => false)
      e.editable?.should be_false
    end

    it "knows if it's repeatable" do
      e = Factory(:event_type, :repeatable => false)
      e.repeatable?.should be_false
    end

    it "writes the event name using the class event_name_formatter" do
      EventType.should_receive(:event_name_formatter).with(" my event")
      e_type = EventType.create( :name => " my event")
    end

    it "can set the name" do
      e_type = EventType.new
      e_type.name=" My other event"
      e_type.name.should == "My Other Event"

      e_type2 = EventType.create(:name => " my event")
      e_type2.name.should == "My Event"
    end

    it "knows if it is used by events" do
      e_type = EventType.create(:seq => 1, :name => "Test event")
      e_type.is_used?.should be_false
      e_type.involvement_events.should_receive(:empty?).and_return(false)
      e_type.is_used?.should be_true
    end

    it "will not delete if it is used" do
      e_type = EventType.create(:name => "Test event")
      e_type.destroy
      e_type.destroyed?.should be_true

      e_type2 = EventType.create(:name => "Test event2")
      e_type2.involvement_events.should_receive(:empty?).and_return(false)
      e_type2.destroy
      e_type2.destroyed?.should be_false
      e_type2.errors.should_not be_empty
    end

    it "provides values for how to adjust the enrollment" do
      EventType::ENROLLMENT_INCR.each do |inr|
        EventType.create(:name => inr).enrollment_adjustment.should == 1
      end
      EventType::ENROLLMENT_DECR.each do |dcr|
        EventType.create(:name => dcr).enrollment_adjustment.should == -1
      end
      %w(foo bar baz bliz).each do |non|
        EventType.create(:name => non).enrollment_adjustment.should == 0
      end
    end
  end

end
