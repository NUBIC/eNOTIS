require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Involvement do
  before do
    ResqueSpec.reset!
  end
  before(:each) do
    @involvement = Factory(:involvement)
    EmpiWorker.should have_queued(@involvement.id)
  end

  it "should create a new instance given valid attributes" do
    @involvement.should be_valid
  end

  it "should accept gender, ethnicity, and race (case insensitive) and set the right case" do
    Involvement.new(:gender => "FEMALE").gender.should == "Female"
    Involvement.new(:gender => "m").gender.should == nil
    Involvement.new(:ethnicity => "HiSpAnIc Or LaTiNo").ethnicity.should == "Hispanic or Latino"
    Involvement.new(:races => "asian").races.include?("Asian").should be_true
  end

  describe "NIH Race requirements" do
    before(:each) do
      @i = Involvement.new(:gender => "Male", :ethnicity => "Hispanic or Latino", 
                           :races => ["American Indian/Alaska Native", "Asian"])
    end

    it "accepts multiple races as per NIH requirements" do
      @i.races.include?("American Indian/Alaska Native").should be_true
      @i.races.include?("Asian").should be_true
    end

    it "accepts race being set via 'races' or 'race'" do
      @i.race = "Asian"
      @i.races.include?("Asian").should be_true
      @i.races = ["Asian", "White"]
      @i.race.include?("Asian").should be_true
      @i.race.include?("White").should be_true
    end

    it "allows setting a race or unknown_not_reported, but not both" do
      @i.race = ["Asian", "Unknown or Not Reported"]
      @i.race.include?("Asian").should be_false
      @i.race.include?("Unknown or Not Reported").should be_true
    end

    it "allows setting unknown race attr direct" do
      @i.race = ["Asian","White"]
      @i.race_is_asian.should be_true
      @i.race_is_white.should be_true
      @i.race_is_unknown_or_not_reported.should be_false
      @i.unknown_or_not_reported_race=true
      # Checking the inversion
      @i.race_is_asian.should be_false
      @i.race_is_white.should be_false
      @i.race_is_unknown_or_not_reported.should be_true
    end

    it "sets the attr for unknown race with 'true' or '1'" do
      @i.race_is_unknown_or_not_reported = false
      @i.unknown_or_not_reported_race="1" # using an int
      @i.race_is_unknown_or_not_reported.should be_true
      @i.race_is_unknown_or_not_reported = false
      @i.unknown_or_not_reported_race=true # using the bool
      @i.race_is_unknown_or_not_reported.should be_true
    end

    it "sets the attr for unknown race with 'false' or '0'" do
      @i.race_is_asian = true
      @i.race_is_unknown_or_not_reported = true
      @i.unknown_or_not_reported_race="0" # using an int
      @i.race_is_unknown_or_not_reported.should be_false
      @i.race_is_unknown_or_not_reported = true
      @i.unknown_or_not_reported_race=false # using the bool
      @i.race_is_unknown_or_not_reported.should be_false
      @i.race_is_asian.should be_true #no other attrs should be effected if we set unknown to false
    end

    it "unsets unknown race flag if a race is chosen" do
      @i.race_is_unknown_or_not_reported = true
      @i.race = ["White","Asian"]
      @i.race_is_asian.should be_true
      @i.race_is_white.should be_true
      @i.race_is_unknown_or_not_reported.should be_false
    end

    it "involvment is not valid unless one of the race attrs are set" do
      @i.send(:clear_all_races)
      @i.valid?.should be_false
      @i.race_is_black_or_african_american = true
      @i.valid?.should be_true
    end

    it "sets attrs using the attributes setter" do
      p = {
    "race_is_white"=>"0", 
    "ethnicity"=>"Not Hispanic or Latino", 
    "case_number"=>"ntnthn98798", 
    "race_is_american_indian_or_alaska_native"=>"0", 
    "gender"=>"Female",
    "race_is_black_or_african_american"=>"1", 
    "race_is_asian"=>"1", 
    "race_is_native_hawaiian_or_other_pacific_islander"=>"1", 
    "unknown_or_not_reported_race"=>"0"}
      @i.send(:clear_all_races)    
      @i.race.should be_empty
      @i.attributes = p
      @i.race_is_black_or_african_american.should be_true
      @i.race_is_asian.should be_true
      @i.race.first.should == "Asian"
    
    end
    
  end

  it "should handle two digit years in dates" do
    @involvement.update_attributes("subject_attributes"=> {"birth_date"=>"12/18/34"})
    @involvement.subject.birth_date.should == Date.parse("1934-12-18")

    @involvement.update_attributes("subject_attributes"=> {"birth_date"=>"12/18/07"})
    @involvement.subject.birth_date.should == Date.parse("2007-12-18")
  end
end
