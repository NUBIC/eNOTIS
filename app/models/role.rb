class Role < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :study
  
  validates_presence_of :netid
  validates_presence_of :study_id
  validates_presence_of :project_role
  
  before_save :truncate_project_role
  
  # Named scopes
  default_scope :order => "project_role"
  
  def last_name
    if p = Bcsec.authority.find_user(netid)
      p.last_name
    else
      netid
    end
  end

  def last_first_middle
    if p = Bcsec.authority.find_user(netid)
      "#{p.last_name}, #{p.first_name} #{p.middle_name}"
    else
      netid
    end
  end

  def can_accrue?
    consent_role == "Obtaining"
  end
 
  # When importing from a webservice or other external source
  # use this method to ensure proper setting of the data 
  # and associated variables
  def self.import_update(study, roles_data)
    # Add any new roles for this study
    roles_data.each do |role_hash|
      unless Role.find(:first, :conditions => role_hash.merge({:study_id => study.id}))
        role_hash[:netid] = role_hash[:netid].downcase # formatting bug fix
        Role.create(role_hash.merge({:study_id => study.id}))
      end
    end
    current_roles = find_all_by_study_id(study.id)
    # For the current roles, remove the ones not in the roles data bulk list
    current_roles.each do |c_role|
      found_in_roles_data = false
      roles_data.each do |n_role|
        # Being very explicit about what data we care about
        if n_role[:netid] == c_role[:netid] and 
          n_role[:project_role] == c_role[:project_role] and
          n_role[:consent_role] == c_role[:consent_role]
          
          found_in_roles_data = true
        end
      end
      Role.delete(c_role) unless found_in_roles_data   
    end
  end

  private
  
  # Fix for authorized personnel entry for study STU00005280
  # Project role is way to long. This should go away
  # once the new irb intake form goes live
  def truncate_project_role
    if self.project_role && self.project_role.length > 255
      self.project_role = self.project_role[0..250] + "..."
    end
  end
end
