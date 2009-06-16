require File.dirname(__FILE__) + '/../spec_helper'

describe WebServices do
  before(:each) do
     @subject = Subject.new
     @subject.mrn = "1234"
     @subject.last_name = "local"
     @subject.first_name = "local"
     @subject.save
  end
  it " should return Subject from local db if it exists" do
    @subject_2 = Subject.find(:first,:conditions=>["mrn='1234'"],:span=>:local)
    @subject_2.first_name.should == "local"

  end
  it "should retrieve subject from edw if it does not exist locally" do
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_2.mrn.should == "9988104"
  end
  
  it "should not save values retrieved from the edw if they do not exist locally" do
    initial_size = Subject.find(:all)
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    Subject.find(:all).should == initial_size
  end

  it "should create a reconcile date that equals time of call" do
    initial_time  = Time.now
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_2.last_reconciled.should >= initial_time
    @subject_2.last_reconciled.should <= Time.now 
  end

  it "should update last reconliled date if global is called, and local copy is expired" do
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_2.last_reconciled = 30.hours.ago
    @subject_2.save
    last_reconcile_date = @subject_2.last_reconciled
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_2.save
    @subject_2.last_reconciled.should > last_reconcile_date
  end

  it "should update attributes if global is called and local copy is expired" do 
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_2.last_reconciled = 30.hours.ago
    original_name = @subject_2.first_name
    @subject_2.first_name = "bubu"
    @subject_2.save
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_2.first_name.should == original_name
  end

  it "should not update attributes if global is called and local copy is not expired" do 
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    original_name = @subject_2.first_name
    @subject_2.first_name = "bubu"
    @subject_2.save
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_2.first_name.should == "bubu"
  end

  it "should call force a foreign call regardless of local content if option :foreign is specifiend for span" do
    @subject_2 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_2.save
    
    @subject_3 = Subject.find(:first,:conditions=>["mrn='9988104'"],:span=>:global)
    @subject_3.id.should != @subject_2.id
    
  end
  
  

end
