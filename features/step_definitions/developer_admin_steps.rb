Given /^an admin "([^\"]*)"$/ do |netid|
  user = Factory.create(:user, {:netid => netid})#, :password => password})
  User.stub!(:authenticate).and_return(user)
  User.stub!(:admin?).and_return(true)
end
