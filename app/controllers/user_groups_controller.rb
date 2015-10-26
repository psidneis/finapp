class UserGroupsController < ApplicationController
  before_action :set_user_group, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @user_groups = UserGroup.all
    respond_with(@user_groups)
  end

  def show
    respond_with(@user_group)
  end

  def new
    @user_group = UserGroup.new
    respond_with(@user_group)
  end

  def edit
  end

  def create
    @user_group = UserGroup.new(user_group_params)
    @user_group.save
    respond_with(@user_group)
  end

  def update
    @user_group.update(user_group_params)
    respond_with(@user_group)
  end

  def destroy
    @user_group.destroy
    respond_with(@user_group)
  end

  private
    def set_user_group
      @user_group = UserGroup.find(params[:id])
    end

    def user_group_params
      params.require(:user_group).permit(:enabled, :role, :group_id, :user_id)
    end
end
