class UserGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_group, only: [:show, :edit, :update, :destroy, :enable, :disable]
  before_action :set_group, only: [:index, :show, :new, :edit, :create, :update, :destroy, :enable, :disable]
  after_action :verify_authorized, except: [:index, :new, :create]

  respond_to :html

  def index
    @user_groups = policy_scope(UserGroup)
    @user_groups = @user_groups.where(group: @group)
    respond_with(@user_groups)
  end

  def show
    respond_with(@user_group)
  end

  def new
    @user_group = @group.user_groups.build
    respond_with(@user_group)
  end

  def edit
  end

  def create
    @user_group = @group.user_groups.build(user_group_params)
    @user_group.search_user
    if @user_group.save and current_user != @user_group.user
      UserGroupMailer.invite_user_to_group(current_user, @user_group).deliver_now!
      @user_group.notify_user
    end
    respond_with(@group, @user_group)
  end

  def update
    @user_group.update(user_group_params)
    respond_with(@group, @user_group)
  end

  def destroy
    @user_group.destroy
    respond_with(@user_group, location: group_user_groups_path(@group))
  end

  def enable
    @user_group.update_attribute(:enabled, true)
    flash[:notice] = t('models.user_group.enabled')
    redirect_to home_dashboard_path
  end

  def disable
    @user_group.update_attribute(:enabled, false)
    flash[:notice] = t('models.user_group.disabled')
    redirect_to home_dashboard_path
  end

  private
    def set_user_group
      @user_group = UserGroup.find(params[:id])
      authorize @user_group
    end

    def user_group_params
      params.require(:user_group).permit(:enabled, :role, :group_id, :email)
    end

    def set_group
      @group = Group.find(params[:group_id])
    end
end
