require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Study do

  before(:each) do
    @fake_data = {:foo => "bar", :irb_number => "STU00005151",
      "coordinators" => [{"name" => "sally", :netid => "soc210"}],
      "principal_investigators"=>[{"name" => "boop"},{"name" => "bop"}]}

    Study.stub!(:cache_doc).and_return(@fake_data)
    @study = Factory(:study)
    @study.refresh_cache
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

    before(:each) do
      @fake_studies = {"rows" => [
        {"key" => "STU0123", "value" => {"irb_number" => "STU0123", "name" => "Study A"}},
        {"key" => "STU0412", "value" => {"irb_number" => "STU0412", "name" => "Study B"}},
        {"key" => "STU02345", "value" => {"irb_number" => "STU02345","name" => "Study C"}}
      ]}
    end

    it "creates studies in the local database with the studies in couchdb" do
      Study.should_receive(:cache_view).with(:all).and_return(@fake_studies)           
      Study.delete_all
      Study.find(:all).should be_empty
      Study.update_all_from_cache
      @fake_studies["rows"].each do |s|
        Study.find(:all).map{|m| m["irb_number"]}.should include(s["value"]["irb_number"])
      end
    end

    it "updates studies in the local db with study data in the cache" do
      Study.should_receive(:cache_view).with(:all).and_return(@fake_studies)      
      Study.update_all_from_cache
      study = Study.find_by_irb_number("STU0123")
      study.should_not be_nil
      study.name.should == "Study A"
      @fake_studies = {"rows" => [{"key" => "STU0123", "value" => {"irb_number" => "STU0123", "name" => "Updated Study A"}}]}

      Study.should_receive(:cache_view).with(:all).and_return(@fake_studies)      
      Study.update_all_from_cache
      study = Study.find_by_irb_number("STU0123")
      study.should_not be_nil
      study.name.should == "Updated Study A"
    end

    describe "updates to coordinators list from cache" do
      before(:each) do 
        Study.should_receive(:cache_view).with(:all).and_return(@fake_studies)      
        Study.update_all_from_cache
        fake_coords = {"rows" => [
          {"key" => "STU0123", "value" => [{"netid" => "mjr120"},{"netid" => ''}]},
          {"key" => "STU0412", "value" => [{"netid" => nil}]},
          {"key" => "STU02345","value" => [{"netid" => ''}]}
        ]}
        Study.should_receive(:cache_view).with(:access_list).and_return(fake_coords)
      end

      it "imports new coordinators" do
        Study.update_coordinators_from_cache
        s = Study.find_by_irb_number("STU0123")
        s.coordinators.should have(1).coordinator
      end

      it "does not import empty netid users" do
        Study.update_coordinators_from_cache
        s = Study.find_by_irb_number("STU02345")
        s.coordinators.should have(0).coordinators
      end

      it "does not import nil netid users" do
        Study.update_coordinators_from_cache
        s = Study.find_by_irb_number("STU0412")
        s.coordinators.should have(0).coordinators
      end

      it "removes existing coordinator list" do
        alt_coords = {"rows" => [
          {"key" => "STU0123", "value" => []},
          {"key" => "STU0412", "value" => [{"netid" => "mjr120"}]},
        ]}
        Study.update_coordinators_from_cache
        s = Study.find_by_irb_number("STU0123")
        s.coordinators.should have(1).coordinators
        
        # replacing the data
        Study.should_receive(:cache_view).with(:access_list).and_return(alt_coords)
        Study.update_coordinators_from_cache
        
        s = Study.find_by_irb_number("STU0123")
        s.coordinators.should have(0).coordinators

        s = Study.find_by_irb_number("STU0412")
        s.coordinators.should have(1).coordinators
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
      @study.cache_foo.should == "bar"
      @study.cache_coordinators.should == @fake_data["coordinators"]
    end

    it "does not clobber the irb_number attribute that is already defined" do
      # we cleverly placed the wrong irb_number in the fake data field
      @study.irb_number.should == "STU0001031" # and NOT what came in with the fake data
    end

  end
end
