require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

#class TestModController < ActionController::Base
#  include(AuthMod)
#end

describe AuthMod do
attr_accessor :controller
  before(:each) do
    @controller = Class.new(ActionController::Base){ include AuthMod }.new
    @controller.session = {}
    @account = User.new
    @account.id = 123
    @account.netid = 'abc123'
    @account.password = 'foo'
    User.stub!(:find).and_return(@account)
    User.stub!(:find_by_netid).and_return(@account)
 end

  it "authenticates the user creditials" do

    User.should_receive(:find_and_validate).with('abc123','foo').and_return(@account)
    controller.authenticate_user('abc123','foo')
    controller.current_user.should == @account
  end

  it "can check to see if the user is logged in" do
    #with no session var set
    controller.logged_in?.should be_false
    controller.authenticate_user('abc123', 'foo')
    controller.logged_in?.should be_true
    controller.current_user.should == @account
  end

end
