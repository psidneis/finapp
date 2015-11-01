class UserPolicy < ApplicationPolicy
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
        scope.where(id: user.id)
      end
    end

end
