require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Involvement do
  before do
  #  ResqueSpec.reset!
  end

  it "enques the involvement" do
    involvement = Factory(:involvement)
    EmpiWorker.should have_queued(involvement.id)
  end

  it "should accept gender, ethnicity, and race (case insensitive) and set the right case" do
    Involvement.new(:gender => "FEMALE").gender.should == "Female"
    Involvement.new(:gender => "m").gender.should == nil
    Involvement.new(:ethnicity => "HiSpAnIc Or LaTiNo").ethnicity.should == "Hispanic or Latino"
    Involvement.new(:races => "asian").races.include?("Asian").should be_true
  end

  describe "bulk importing process for involments managed on other studies" do

    before(:each) do
      @study = Factory(:study, :irb_number => "STU000123")
      @dhash = [{
          :subject => {
            :external_patient_id=>"5587555",
            :nmff_mrn=>"123321",
            :first_name=>"Traci",
            :last_name=>"Smith",
            :birth_date=>"1/11/1955",
            :death_date=>"",
            :import_source => 'NOTIS'
          },
          :involvement => {
            :ethnicity=>"Not Hispanic or Latino",
            :gender=>"Female",
            :address_line1=>"50 W. Street",
            :address_line2=>"Apt 106",
            :zip=>"10642",
            :case_number=>"1106",
            :race_is_black_or_african_american => true,
            :home_phone=>"3215551233",
            :state=>"IL",
            :city=>"Chicago",
            :involvement_events => {:consented_date => "12/21/2004",
             :completed_date => "3/10/2009"}
           }
      }]
    end

    def first_involvement
      Study.find_by_irb_number(@study.irb_number).involvements.first
    end

    it "adds involvement for study given the involvement/subject data" do
      @study.involvements.count.should == 0
      Involvement.import_update(@study, @dhash)
      @study.involvements.count.should == 1
      first_involvement.involvement_events.count.should == 2
    end

    it "does not create duplicate involvements for the same study/subject" do
      @study.involvements.count.should == 0
      Involvement.import_update(@study, @dhash)
      Involvement.import_update(@study, @dhash)
      @study.involvements.count.should == 1
    end

    # pulled from the importer spec and dumped here cause it's closer to the problem
    it "should scope subjects to the source system when looking them up by the external id" do
        s1 = Factory(:study)
        s1.managed_by('NOTIS')
        s2 = Factory(:study)
        s2.managed_by('ANES')
        subj_ANES = [{
            :subject => {
              :external_patient_id=>"123", #<<- this is what we're testing
              :nmff_mrn=>"091823888",
              :first_name=>"LORI",
              :last_name=>"MIAOS",
              :birth_date=>"2/26/1982",
              :import_source => 'ANES'
             },
            :involvement => {
              :case_number=>"105",
              :ethnicity=>"Not Hispanic or Latino",
              :gender=>"Female",
              :race_is_white => true,
              :involvement_events => {
                :consented_date => "2011-02-10",
                :completed_date => "2011-02-10"}
            }}]

         subj_NOTIS = [{
            :subject => {
              :external_patient_id=>"123", #<<- this what we're testing
              :nmff_mrn=>"123321",
              :first_name=>"Traci",
              :last_name=>"Smith",
              :birth_date=>"1/11/1955",
              :import_source => 'NOTIS'
             },
            :involvement => {
              :case_number=>"1106",
              :address_line1=>"50 W. Street",
              :address_line2=>"Apt 106",
              :zip=>"10642",
              :home_phone=>"3215551233",
              :state=>"IL",
              :city=>"Chicago",
              :ethnicity=>"Not Hispanic or Latino",
              :gender=>"Female",
              :race_is_black_or_african_american => true,
              :involvement_events => {
                :consented_date => "1/12/2010",
                :completed_date => "1/11/2011"}
            }}]
          Involvement.import_update(s1, subj_ANES)
          Involvement.import_update(s2, subj_NOTIS)
          sub1 = s1.involvements.first.subject
          sub2 = s2.involvements.first.subject
          sub1.id.should_not == sub2.id #same external id should not link to same internal obj!!!
      end

    describe "updates data on existing study/subject involvements" do
      it "adds withdrawl date removes completed date" do
        Involvement.import_update(@study, @dhash)
        first_involvement.event_detect("Completed").should_not be_nil
        @dhash.first[:involvement][:involvement_events].delete(:completed_date)
        @dhash.first[:involvement][:involvement_events][:withdrawn_date] = "2-9-2007"
        Involvement.import_update(@study, @dhash)
        first_involvement.event_detect("Completed").should be_nil
        ie = first_involvement.event_detect("Withdrawn")
        ie.should_not be_nil
        (Chronic.parse(ie.occurred_on.to_s)).should == Chronic.parse("2-9-2007")
      end

      it "edits an event date (consent date)" do
        Involvement.import_update(@study, @dhash)
        ie = first_involvement.event_detect("Completed")
        (Chronic.parse(ie.occurred_on)).should == Chronic.parse("3/10/2009")
        # changing the date
        @dhash.first[:involvement][:involvement_events][:completed_date] = "4/10/2010"

        Involvement.import_update(@study, @dhash)
        ie = first_involvement.event_detect("Completed")
        (Chronic.parse(ie.occurred_on)).should == Chronic.parse("4/10/2010")
      end

      it "deletes an event (completed)" do
        Involvement.import_update(@study, @dhash)
        ie = first_involvement.event_detect("Completed")
        (Chronic.parse(ie.occurred_on)).should == Chronic.parse("3/10/2009")
        @dhash.first[:involvement][:involvement_events].delete(:completed_date)

        # reloading with changes
        Involvement.import_update(@study, @dhash)
        ie = first_involvement.event_detect("Completed")
        ie.should be_nil
      end

    end

    it "deletes involvements for subjects who are no longer on the study, does not delet the subject" do
      # Deleted subjects we are assuming were added in error and it's therfore, okay to delete them.
      Involvement.import_update(@study, @dhash)
      @study.involvements.count.should == 1
      sub = first_involvement.subject
      Involvement.import_update(@study, [])
      @study.involvements.count.should == 0
      Subject.find(sub.id).should_not be_nil
    end

  end

  describe "how it should tranlsate (for more forgiving uploads) gender terms" do
    #positive matches
    p_match = {
      "Male" => %w(male M m MALE),
      "Female" => %w(female F f FEMALE),
      "Unknown or Not Reported" => %w(u NR U nr UNKNOWN unknown not\ reported)}

    p_match.each do |output, str2test|
      it "should translate '#{str2test}' to '#{output}'" do
        str2test.each{|s| Involvement.translate_gender(s).should == output}
      end
    end

    #negative matches
    n_match = %w(not\ male girl null not\ known reported)
    n_match.each do | str2test|
      it "should NOT match '#{str2test}'. Should be nil" do
        str2test.each{|s| Involvement.translate_gender(s).should be_nil}
      end
    end

    Involvement.translate_gender(nil).should == nil
  end

  describe "how it should tranlsate (for more forgiving uploads) ethnicity terms" do
    #positive matches
    p_match = {
      "Hispanic or Latino" => %w(hispanic\ or\ latino hispanic latino latino\ or\ hispanic),
      "Not Hispanic or Latino" => ["not hispanic", "not hispanic or latino", "not latino", "not latino or hispanic"],
      "Unknown or Not Reported" => %w(u NR U nr UNKNOWN unknown not\ reported)}

    p_match.each do |output, str2test|
      it "should translate '#{str2test}' to '#{output}'" do
        str2test.each{|s| Involvement.translate_ethnicity(s).should == output}
      end
    end

    #negative matches
    n_match = %w(not null not\ known reported)
    n_match.each do | str2test|
      it "should NOT match '#{str2test}'. Should be nil" do
        str2test.each{|s| Involvement.translate_ethnicity(s).should be_nil}
      end
    end

    it "should return nil for nil" do
      Involvement.translate_ethnicity(nil).should be_nil
    end
  end

  describe "how it should tranlsate (for more forgiving uploads) race terms" do
    p_match = {
       "American Indian/Alaska Native" => ["American Indian/Alaska Native", "american indian", "alaskan", "alaska native", "native american"],
       "Asian" => %w(asian Asian),
       "Black/African American" => ["Black/African American", "black", "africaN", "African American"],
       "Native Hawaiian/Other Pacific Islander" => ["Native Hawaiian/Other Pacific Islander", "Hawaiian", "Pacific islander", "other pacific islander", "native pacific islander"],
       "White" => ["White", "Caucasian", "White/Caucasian"],
       "Unknown or Not Reported" => %w(u NR U nr UNKNOWN unknown not\ reported)}

    p_match.each do |output, str2test|
      it "should translate '#{str2test}' to '#{output}'" do
        str2test.each{|s| Involvement.translate_race(s).should == output}
      end
    end

    #negative matches
    n_match = ["null", "not known", "reported", "not alaska native", "native", "indian", "Asian American", "NOt Asian", "a Black", "american",
      "not Hawaiian", "pacific", "not white", "w"]
    n_match.each do | str2test|
      it "should NOT match '#{str2test}'. Should be nill" do
        str2test.each{|s| Involvement.translate_race(s).should be_nil}
      end
    end

    it "should be nil for nil" do
      Involvement.translate_race(nil).should == nil
    end
 end

  it "should destroy child involvement events" do
    i = Factory(:involvement)
    e1 = Factory(:involvement_event, :involvement => i, :occurred_on => 1.day.ago)
    e2 = Factory(:involvement_event, :involvement => i, :occurred_on => 2.days.ago)
    i.involvement_events.should have(2).children
    i.destroy
    InvolvementEvent.find_by_id(e1.id).should be_nil
    InvolvementEvent.find_by_id(e2.id).should be_nil
  end


  describe "working with custom event_type methods" do
    before(:each) do
      @study = Factory(:study)
      @study.create_default_events
      @subject = Factory(:subject)
      @involvement = Factory(:involvement,
                           :races => ["White", "Asian"],
                           :study => @study,
                           :subject => @subject,
                           :case_number => "123abc123")
      # Adding all the events for testing purposes
      @event_date = "01/13/2010"
      %w(Consented Completed Withdrawn).each do |n|
        ev = @study.event_types.find_by_name(n)
        Factory(:involvement_event, :involvement => @involvement, :occurred_on => @event_date, :event_type => ev)
      end
      @involvement.involvement_events.should have(3).events
    end

    it "should help find involvement event by name" do
      @involvement.involvement_events.should have(3).events
      %w(Consented Completed Withdrawn).each do |n|
        @involvement.event_detect(n).should_not be_nil
        @involvement.event_detect(n).occurred_on.strftime("%m/%d/%Y").should == @event_date
      end
    end
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

    it "involvement is not valid unless one of the race attrs are set" do
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
    inv = Factory(:involvement)
    inv.update_attributes("subject_attributes"=> {"birth_date"=>"12/18/34"})
    inv.subject.birth_date.should == Date.parse("1934-12-18")
    inv.update_attributes("subject_attributes"=> {"birth_date"=>"12/18/07"})
    inv.subject.birth_date.should == Date.parse("2007-12-18")
  end

  it "should sort involvements by case number by default" do
    s = Factory(:study)
    i1 = Factory(:involvement, :study => s, :case_number => "99")
    i2 = Factory(:involvement, :study => s, :case_number => "2")
    s.involvements.should == [i2, i1]
  end

  describe 'named event accessors' do
    before do
      @study = Factory(:study)
      @all_events = Factory(:involvement, :study => @study)
      @study.event_types.each do |type|
        @all_events.involvement_events <<
          Factory(:involvement_event,
          :involvement => @all_events, :event_type => type, :occurred_on => Date.new(2010, 3, 7))
      end
      @no_events = Factory(:involvement, :study => @study)
    end

    %w(consented withdrawn completed).each  do |name|
      describe "##{name}" do
        it 'gives the correct event when a match exists' do
          @all_events.send(name).event_type.name.should == name.titlecase
        end

        it 'gives nothing when no match exists' do
          @no_events.send(name).should be_nil
        end
      end

      describe "##{name}_report" do
        it 'gives the date for the event when a match exists' do
          @all_events.send("#{name}_report").should == Date.new(2010, 3, 7)
        end

        it 'gives nil when no match exists' do
          @no_events.send("#{name}_report").should be_nil
        end
      end
    end
  end
end
