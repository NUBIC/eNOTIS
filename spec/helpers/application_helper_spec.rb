require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do

  it "should format involvement events" do
    @involvement = Factory(:involvement)
    @involvement_event = Factory(:involvement_event, :event_type => Factory(:event_type, :name => "Consented#{rand(100)}"), :involvement => @involvement, :occurred_on => "1/1/10")
    helper.event_info(@involvement_event).should =~ /01\/01\/2010/
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
