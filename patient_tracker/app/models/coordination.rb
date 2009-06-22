# This model handles the relationship between a user and their role 
# as study coordinator.  
#
# NOTE: blc06/18/09
# ===================
# This replaced the study access model we had previously. I made this 
# change because "study access" was somewhat abiguous. Technically 
# every user in eNotis has access to studies, what we are really trying
# to represent with this named join model is that this user can act
# as a study coordinator and add patients. However, because eIRB, the
# source system, only providies us with one list of users per study
# we give everyone in that list the same level of access... the 
# level of access a coordinator has.
# ===================
#


class Coordination < ActiveRecord::Base
  belongs_to :user
  belongs_to :study
end
