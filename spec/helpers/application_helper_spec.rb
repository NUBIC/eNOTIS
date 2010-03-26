require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  it "should find involvement events and format them" do
    @involvement = Factory(:involvement)
    @involvement_event = Factory(:involvement_event, :event => "Consented", :involvement => @involvement, :occurred_on => "1/1/10")
    helper.event_info(@involvement, "Consented").should =~ /2010-01-01/
  end
  it "should find involvement events in mixed case" do
    @involvement = Factory(:involvement)
    @involvement_event = Factory(:involvement_event, :event => "Consented", :involvement => @involvement, :occurred_on => "1/1/11")
    helper.event_info(@involvement, "consented").should =~ /2011-01-01/
    helper.event_info(@involvement, "CONsented").should =~ /2011-01-01/
  end

end
