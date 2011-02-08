# Current Role schema:
#   create_table "roles", :force => true do |t|
#    t.integer  "study_id"
#    t.integer  "user_id"
#    t.string   "project_role"
#    t.string   "consent_role"
#    t.datetime "created_at"
#    t.datetime "updated_at"
#    t.string   "netid"
#  end
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do
  before(:each) do 
    #@user = Factory(:user, :netid => "abc123")
    @netid='abc123'
    @study = Factory(:study, :irb_number => "STU0010101")
    @role = Factory(:role, :netid => @netid, :study => @study)
  end

  it "should create a new instance given valid attributes" do
    @role.should be_valid
    @study.roles.map(&:netid).include?("abc123").should be_true
  end
 
  it "should create a new instance given valid attributes (fake study)" do
    @role.should be_valid
    @study.roles.map(&:netid).include?("abc123").should be_true
  end

  it "can or cannot accrue patients" do
    can_role = Factory(:role, :netid => @netid,
                       :study => @study, 
                       :consent_role => "Obtaining")
    cannot_role = Factory(:role, :netid => @netid,
                       :study => @study, 
                       :consent_role => "None")
    can_role.can_accrue?.should be_true
    cannot_role.can_accrue?.should be_false
  end
 
  # TODO: Perhaps it should be by standard study role sorting (PI, Co-Inv, Coords, other)
  it "should return roles in alpha older by project role" do
    @study = Factory(:study, :irb_number => "STU0010102")
    @r1 = Factory(:role, :netid => "111yyy", :study => @study, :project_role => "PI")
    @r2 = Factory(:role, :netid => "222zzz", :study => @study, :project_role => "Coordinator")
    @study.roles.should == [@r2, @r1]
  end
  
  it "should be invalid without netid or study" do
    Role.new(:netid => 'test').should have(1).error_on(:study_id)
    Role.new(:study_id => 1).should have(1).error_on(:netid)
  end
  
  it "should print last name" do
    Pers::Person.stub!(:find_by_username).and_return(mock(Pers::Person, :last_name => "Smith"))
    Factory(:role, :netid => "smithy").last_name.should == "Smith"
  end

  it "should print last name, first middle" do
    Pers::Person.stub!(:find_by_username).and_return(mock(Pers::Person, :last_name => "Smith", :first_name => "John", :middle_name => "Q"))
    Factory(:role, :netid => "smithy").last_first_middle.should == "Smith, John Q"
  end

  it "should not be valid without a project role and netid" do
    no_pi_role = Role.new( :netid => nil, :study => Factory(:study), :project_role => "Oversight")
    no_pi_role.valid?.should be_false
    no_pi_role.should have(1).error_on(:netid)
    no_role_role = Role.new(:netid => "ba123", :study => Factory(:study), :project_role => "")
    no_role_role.valid?.should be_false
    no_role_role.should have(1).error_on(:project_role)
  end

  describe "importing from bulk data" do
   
    before(:each) do
      @study = Factory(:study)
      @roles_data = [
        {:netid => "abc123", :project_role => "PI", :consent_role => "None" },
        {:netid => "bct555", :project_role => "Coord", :consent_role => "Obtaining" },
        {:netid => "hhh123", :project_role => "Co-Inv", :consent_role => "None" },
      ]
      Role.bulk_update(@study.id, @roles_data)
      @study.roles.count.should == 3
    end

    it "should create the roles in a data hash" do
      pi = @study.roles.find_by_netid("abc123")
      pi.project_role.should == "PI"
      pi.consent_role.should == "None"
    end

    it "should not create duplicate roles given the same hash twice" do
      Role.bulk_update(@study.id, @roles_data)
      @study.roles.count.should == 3
    end

    it "updates  when some data is changed (consent role)" do
      # updating some data
      @roles_data[0][:consent_role].should == "None"
      @roles_data[0] = {:netid => "abc123", :project_role => "PI", :consent_role => "Obtaining"}
      @roles_data[0][:consent_role].should == "Obtaining"
      Role.bulk_update(@study.id, @roles_data)
      @study.roles.find_by_netid("abc123").consent_role.should == "Obtaining"
    end

    it "deletes when data is removed (pi change/no coord)" do
      new_data = [
        {:netid => "zzz123", :project_role => "PI", :consent_role => "Obtaining"},
        {:netid => "abc123", :project_role => "Co-Inv", :consent_role => "None"}
      ]

      Role.bulk_update(@study.id, new_data)
      old_pi = @study.roles.find_all_by_netid("abc123")
      old_pi.count.should == 1
      old_pi.first.project_role.should == "Co-Inv"
      new_pi = @study.roles.find_all_by_netid("zzz123")
      new_pi.count.should == 1
      new_pi.first.project_role.should == "PI"
    end

    it "allows people to occupy multiple roles" do
      new_data = [
        {:netid => "aoe123", :project_role => "PI", :consent_role => "None"},
        {:netid => "aoe123", :project_role => "Data Manager", :consent_role => "Obtaining"}
      ]
      Role.bulk_update(@study.id, new_data)
      @study.roles.count.should == 2
      @study.roles.find_all_by_netid("aoe123").count.should == 2
    end

    it "should wipe the data if given none" do
      Role.bulk_update(@study.id, [{}])
      @study.roles.count.should == 0
    end

  end

end
