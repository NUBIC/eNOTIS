require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  it "should display mailto links for study staff" do
    # assumptions about static authority
    s = Bcsec.configuration.authorities.find { |a| Bcsec::Authorities::Static === a }
    s.user('adminnie') do |u|
      u.first_name = "Minnie"
      u.last_name = "Admin"
      u.email = "enotis@northwestern.edu"
    end
    s.user('usergey') do |u|
      u.first_name = "Sergey"
      u.last_name = "User"
      u.email = "enotis@northwestern.edu"
    end
    study = Factory(:study)
    Factory(:role_accrues, :netid => "adminnie", :study => study, :project_role => "PI")
    Factory(:role_accrues, :netid => "usergey", :study => study, :project_role => "Coordinator")
    helper.people_info(study.roles).should == "<span title=\"Project Role: Coordinator\"><a href=\"mailto:enotis@northwestern.edu\">Sergey User</a></span><span title=\"Project Role: PI\"><a href=\"mailto:enotis@northwestern.edu\">Minnie Admin</a></span>"
  end
  it "should find involvement events and format them" do
    @involvement = Factory(:involvement)
    @involvement_event = Factory(:involvement_event, :event => "Consented", :involvement => @involvement, :occurred_on => "1/1/10")
    helper.event_info(@involvement, "Consented").should =~ /2010-01-01/
  end
  it "should find involvement events in mixed case" do
    @involvement = Factory(:involvement)
    @involvement_event = Factory(:involvement_event, :event_type => Factory(:event_type, :name => "Consented#{rand(100)}"), :involvement => @involvement, :occurred_on => "1/1/10")
    helper.event_info(@involvement_event).should =~ /01\/01\/2010/
  end

  it "should emphasize the juicy part of the irb_number" do
    helper.irb_span(Study.new(:irb_number => "STU00019833")).should == '<span class="irb_number">STU000<strong>19833</strong></span>'
    helper.irb_span(Study.new(:irb_number => "STU1234")).should == '<span class="irb_number">STU<strong>1234</strong></span>'
    helper.irb_span(Study.new(:irb_number => "STUABC")).should == '<span class="irb_number">STUABC</span>'
    helper.irb_span(Study.new(:irb_number => "")).should == '<span class="irb_number">(no IRB number)</span>'
  end

  it "should emphasize study status" do
    helper.status_span(Study.new(:irb_status => "Approved")).should == '<span class="sortabove status on">Approved</span>'
    helper.status_span(Study.new(:irb_status => "Withdrawn")).should == '<span class="sortbelow status off">Withdrawn</span>'
    helper.status_span(Study.new(:irb_status => "")).should == '<span class="sortbelow status off"></span>'
  end
end
