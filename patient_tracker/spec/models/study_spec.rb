require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Study do
  before(:each) do
    @study= Study.create(:status=>"open",:name=>"test_study",:description=>"some test study",:last_reconciled=>Time.now)
  end


  it "should add a new subject, given an open status" do 
    p = Subject.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @study.save
    @study.add_subject(p)
    @study.involvements.size.should ==1
  end

  it "Should fail to add a new subject if status is not open" do

    p = Subject.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @study.status = "closed"
    @study.save
    @study.add_subject(p)
    @study.involvements.size.should == 0
  end

  it "should add subject on with unconfirmed status if, current reconciliation status is not valid" do
    p = Subject.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @study.last_reconciled = 23.hours.ago
    @study.save
    @study.add_subject(p)
    @study.involvements.size.should ==1
    @study.involvements[0].confirmed.should == false
    
  end

  it "should change subject on study status to confirmed once data is reconciled if status is still open" do
    p = Subject.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @study.last_reconciled = 23.hours.ago
    @study.save
    @study.add_subject(p)
    @study.involvements.size.should ==1
    @study.involvements[0].confirmed.should == false
    @study.reconcile({:status=>"open",:name=>"test_study",:description=>"some test study"})
    @study.involvements.size.should ==1
    @study.involvements[0].confirmed.should == true
  end

  it "should not add a subject to a particular study more than once" do
    p = Subject.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @study.add_subject(p)
    @study.add_subject(p)
    p.involvements.size.should == 1
  end

  it "should return whether or not a user is authorized to work on a given study" do
     u = User.create
     @study.users << u
     (@study.authorized_user?u).should == true
  end


  it "should return false if user is not authorized to work on a given study" do
    u = User.create
    p = Study.create
    p.users << u
    (@study.authorized_user?u).should == false
  end

end
