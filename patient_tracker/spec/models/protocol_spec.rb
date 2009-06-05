require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Protocol do
  before(:each) do
    @protocol= Protocol.create(:status=>"open",:name=>"test_protocol",:description=>"some test protocol",:reconciliation_date=>Time.now)
  end


  it "should add a new patient, given an open status" do 
    p = Patient.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @protocol.save
    @protocol.add_patient(p)
    @protocol.involvements.size.should ==1
  end

  it "Should fail to add a new patient if status is not open" do

    p = Patient.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @protocol.status = "closed"
    @protocol.save
    @protocol.add_patient(p)
    @protocol.involvements.size.should == 0
  end

  it "should add patient on with unconfirmed status if, current reconciliation status is not valid" do
    p = Patient.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @protocol.reconciliation_date = 23.hours.ago
    @protocol.save
    @protocol.add_patient(p)
    @protocol.involvements.size.should ==1
    @protocol.involvements[0].confirmed.should == false
    
  end

  it "should change patient on protocol status to confirmed once data is reconciled if status is still open" do
    p = Patient.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @protocol.reconciliation_date = 23.hours.ago
    @protocol.save
    @protocol.add_patient(p)
    @protocol.involvements.size.should ==1
    @protocol.involvements[0].confirmed.should == false
    @protocol.reconcile({:status=>"open",:name=>"test_protocol",:description=>"some test protocol"})
    @protocol.involvements.size.should ==1
    @protocol.involvements[0].confirmed.should == true
  end

  it "should not add a patient to a particular protocol more than once" do
    p = Patient.create({:first_name=>"david",:last_name=>"kabaka",:mrn=>"123454"})
    @protocol.add_patient(p)
    @protocol.add_patient(p)
    p.involvements.size.should == 1
  end

  it "should return whether or not a user is authorized to work on a given protocol" do
     u = User.create
     @protocol.users << u
     (@protocol.authorized_user?u).should == true
  end


  it "should return false if user is not authorized to work on a given protocol" do
    u = User.create
    p = Protocol.create
    p.users << u
    (@protocol.authorized_user?u).should == false
  end

end
