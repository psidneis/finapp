class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    # registered(user) if user.persisted?
    user.current_user_roles.each do |role|
      # only enabled person_roles
      send(role.parameterize.underscore, user) if respond_to?(role.parameterize.underscore)
    end
  end

  def admin(user)
    can :manage, :all
  end
end
