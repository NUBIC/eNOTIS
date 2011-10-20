class Ability
  include CanCan::Ability
  def initialize(user)
    if user.permit?(:admin)
      can :manage, :all
    else
      #control access for study actions
      can [:show], Study do |study|
        study.has_coordinator?(user)
      end

      can [:edit,:import], Study do |study|
        study.has_coordinator?(user) and !study.is_managed?
      end
      #control access for involvement actions
      can [:destroy,:update,:show], Involvement do |involvement|
        involvement.study.has_coordinator?(user)
      end
    end
  end
end
