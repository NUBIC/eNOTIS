require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Study do
  
  before(:each) do
    @fake_data = {:foo => "bar", :irb_number => "STU00005151",
      "coords" => [{"name" => "sally", :netid => "soc210"}],
      "co_pis"=>[{"name" => "boop"},{"name" => "bop"}]}

    Study.stub!(:couch_doc).and_return(@fake_data)
    @study = Factory(:study)
    @study.irb_number = "STU0001031"
  end

 it "should not be valid with out an irb_number" do
   @study.irb_number = nil
   @study.valid?.should be_false
   @study.irb_number = "STU0001031"
   @study.valid?.should be_true
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

 describe "data from couchdb" do

   it "updates studies that are in the local database with the studies in couchdb" do
     fake_studies = {"rows" => [{"id" => "STU0123"}, {"id" => "STU0421"}, {"id" => "STU02345"}]}
     Study.should_receive(:couch_view).with(:all_status).and_return(fake_studies)
     Study.delete_all
     Study.find(:all).should be_empty
     Study.update_from_cache
     fake_studies["rows"].each do |s|
       Study.find(:all).map(&:irb_number).should include(s["id"])
     end
   end
   
   it "stores the json in the instance object" do
     @study.eirb_json.should_not be_nil
   end

   it "should be json that is converted to a hash" do
     @study.eirb_json.is_a?(Hash).should be(true)
   end

   # Note that it doesn't handle attrs from the json that are arrays of
   # hashes very well. No real good solution for this at this point -BLC
   it "decorates the model with attributes from the json" do
     @study.eirb_json.should == @fake_data
     @study.inspect
     @study.foo.should == "bar"
     @study.coords.should == @fake_data["coords"]
     @study.coords.first["name"].should == "sally"
   end

   it "does not clobber the irb_number attribute that is already defined" do
     # we cleverly placed the wrong irb_number in the fake data field
    @study.irb_number.should == "STU0001031" # and NOT what came in with the fake data
   end
   
 end
end
