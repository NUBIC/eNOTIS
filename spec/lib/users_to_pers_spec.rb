require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'database_cleaner'

describe UsersToPers do
  before(:each) do
    DatabaseCleaner[:active_record, {:connection => :cc_pers_test}]
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
    
    Bcaudit::AuditInfo.current_user = Bcsec::User.new("foo")
    unless(@enotis = Pers::Portal.find_by_name('eNOTIS'))
      @enotis = Pers::Portal.new
      @enotis.portal = "eNOTIS"
      @enotis.save!
    end
  end
  after(:each) do
    DatabaseCleaner.clean
  end
  it "should have eNOTIS as a portal" do
    @enotis.name.should == "eNOTIS"
  end
  it "should be able to create admin and user groups" do
    lambda{ @enotis.groups.create!(:group_name => "Admin")}.should_not raise_error
    lambda{ @enotis.groups.create!(:group_name => "Users")}.should_not raise_error
    @enotis.should have(2).groups
  end

  it "should create an admin" do
    # Pers::Person.create
    # UsersToPers.create_admin("blc615", "Brian", "Chamberlain", "b-chamberlain@northwestern.edu")
  end
end
