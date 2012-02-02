class Ability
  include CanCan::Ability
  def initialize(user)
    if user.admin? #user.permit?(:admin)
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
      can [:show], Involvement do |involvement|
        involvement.study.has_coordinator?(user)
      end
      can [:destroy,:update,:edit], Involvement do |involvement|
        involvement.study.has_coordinator?(user) and !involvement.study.is_managed?
      end
    end
  end
end
