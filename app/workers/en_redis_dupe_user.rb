class ENRedisDupeUser
  @queue = :redis_dupe_user
  def self.perform(irb_number, netid, project_role, consent_role)
  end
end