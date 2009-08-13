Given /^an admin "([^\"]*)"$/ do |netid|
  @user = Factory.create(:user, {:netid => netid})#, :password => password})
  User.stub!(:authenticate).and_return(@user)
  User.stub!(:find_by_id).and_return(@user)
  @user.stub!(:admin?).and_return(true)
end

Given /^the following users$/ do |table|
  table.hashes.each do |hash|
    Factory.create(:user, hash)
  end
end

Given /^the following dictionary terms$/ do |table|
  table.hashes.each do |hash|
    Factory.create(:dictionary_term, hash)
  end
end