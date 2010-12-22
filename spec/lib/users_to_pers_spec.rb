require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'database_cleaner'
require 'truncation' # monkey patch for database_cleaner's truncation: connection with oracle xe ubuntu vm - yoon

describe UsersToPers do
  before(:all) do
    DatabaseCleaner[:active_record, {:connection => Rails.env == 'hudson' ? :cc_pers_hudson : :cc_pers_test}]
    DatabaseCleaner.strategy = :truncation
    Bcaudit::AuditInfo.current_user = Bcsec::User.new('rspec')
  end
  before(:each) do
    DatabaseCleaner.start
  end
  after(:each) do
    DatabaseCleaner.clean
  end
  it "should create eNOTIS as a portal" do
    Pers::Portal.find_by_name('eNOTIS').should be_nil
    UsersToPers.setup
    Pers::Portal.find_by_name('eNOTIS').name.should == 'eNOTIS'
  end
  it "should not attempt to re-create eNOTIS as a portal" do
    enotis = Pers::Portal.new
    enotis.portal = 'eNOTIS'
    enotis.save
    Pers::Portal.should_not_receive(:new)
    lambda{ UsersToPers.setup }.should_not raise_error
  end
  it "should create groups within the eNOTIS portal" do
    Pers::Group.find_by_group_name_and_portal('Admin', 'eNOTIS').should be_nil
    Pers::Group.find_by_group_name_and_portal('User', 'eNOTIS').should be_nil
    UsersToPers.setup
    Pers::Portal.find_by_name('eNOTIS').groups.find_by_group_name('Admin').should_not be_nil
    Pers::Portal.find_by_name('eNOTIS').groups.find_by_group_name('User').should_not be_nil
  end
  it "should not attempt to re-create the groups" do
    enotis = Pers::Portal.new
    enotis.portal = 'eNOTIS'
    enotis.groups.build(:group_name => 'Admin')
    enotis.groups.build(:group_name => 'User')
    enotis.save
    lambda{ UsersToPers.setup }.should_not raise_error
  end
  it "should create admins" do
    UsersToPers.setup
    UsersToPers.create_admins
    %w(blc615 daw286 lmw351 myo628 wakibbe).each do |netid|
      (user = Bcsec.authority.find_user(netid)).should_not be_nil
      user.permit?("Admin").should be_true
    end
  end
  it "should not attempt to re-create admins" do
    UsersToPers.setup
    UsersToPers.create_admins
    lambda{ UsersToPers.create_admins }.should_not raise_error
  end
end
