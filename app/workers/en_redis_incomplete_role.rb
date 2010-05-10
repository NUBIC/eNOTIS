class ENRedisIncompleteRole
  @queue = :redis_incomplete_role
  def self.perform(irb_number, netid, project_role, consent_role)
  end
end