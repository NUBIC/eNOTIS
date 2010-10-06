require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ControllerAuthentication do
  attr_accessor :controller
  before(:each) do
  #  @controller = Class.new(ActionController::Base).new
  #  @controller.extend(ControllerAuthentication)
  #  @controller.session = {}
  #  @account = Factory(:user, {:netid => 'pi314'})#, :password => 'circular'})
  end



  it "should not log in user with no coordinators" do
    pending # This should be handled with the enotis authority
    
    #with no session var set
#    @controller.send(:logged_in?).should be_false
#    @controller.send(:current_user=, @account)
#    @controller.send(:authorized?).should be_false
  end

  it "should log in a user with coordinators" do
    pending # This should be handled with the enotis authority
    
    #with no session var set
  #  @account.studies << Factory(:study)
  #  @controller.send(:logged_in?).should be_false
  #  @controller.send(:current_user=, @account)
  #  @controller.send(:authorized?).should be_true
  end

end
