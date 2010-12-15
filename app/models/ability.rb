class Ability
  include CanCan::Ability
  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      #control access for study actions
      can [:show,:import], Study do |study|
        study.has_coordinator?(user)
      end
      #control access for involvement actions
      can [:destroy,:update,:show], Involvement do |involvement|
        involvement.study.has_coordinator?(user)
      end
    end
  end
end
