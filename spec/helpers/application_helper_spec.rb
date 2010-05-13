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
  it "should emphasize the juicy part of the irb_number" do
    helper.pretty_irb_number(Study.new(:irb_number => "STU00019833")).should == '<span class="irb_number">STU000<strong>19833</strong></span>'
    helper.pretty_irb_number(Study.new(:irb_number => "STU1234")).should == '<span class="irb_number">STU<strong>1234</strong></span>'
    helper.pretty_irb_number(Study.new(:irb_number => "STUABC")).should == '<span class="irb_number">STUABC</span>'
    helper.pretty_irb_number(Study.new(:irb_number => "")).should == '<span class="irb_number">(no IRB number)</span>'
  end
  it "should emphasize study status" do
    helper.pretty_status(Study.new(:irb_status => "Approved")).should == '<span class="sortabove status on">Approved</span>'
    helper.pretty_status(Study.new(:irb_status => "Withdrawn")).should == '<span class="sortbelow status off">Withdrawn</span>'
    helper.pretty_status(Study.new(:irb_status => "")).should == '<span class="sortbelow status off"></span>'
  end
end
