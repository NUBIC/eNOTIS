# This model is used to customize whodunnit
# in the view_trail gem. Instead of recording 
# the User object, record the user's netid

class Activity < ActiveRecord::Base
#  belongs_to :user, :foreign_key => :whodiddit, :class_name => "User"
# This should be the bcsec use and storing the netid in the whodidit field -BLC
# See the application_controller for where we set the whodiddit override method
end
