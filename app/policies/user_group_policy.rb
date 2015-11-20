class UserGroupPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    can_perform_action?
  end

  def create?
    can_perform_action?
  end

  def update?
    can_perform_action?
  end

  def destroy?
    can_perform_action?
  end

  def enable?
    can_perform_action?
  end

  def disable?
    can_perform_action?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  private
    def can_perform_action?
      scope.where(id: record.id).exists?
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        group_ids = Array.new
        group_ids = user.manager_groups.pluck(:id)
        scope.where("group_id in (?) or user_id = ?", group_ids, user.id)
      end
    end

end
