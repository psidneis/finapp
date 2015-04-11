class UserRolesController < ApplicationController
  before_action :set_user_role, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @user_roles = UserRole.all
    respond_with(@user_roles)
  end

  def show
    respond_with(@user_role)
  end

  def new
    @user_role = UserRole.new
    respond_with(@user_role)
  end

  def edit
  end

  def create
    @user_role = UserRole.new(user_role_params)
    @user_role.save
    respond_with(@user_role)
  end

  def update
    @user_role.update(user_role_params)
    respond_with(@user_role)
  end

  def destroy
    @user_role.destroy
    respond_with(@user_role)
  end

  private
    def set_user_role
      @user_role = UserRole.find(params[:id])
    end

    def user_role_params
      params.require(:user_role).permit(:user_id, :role_id, :enabled)
    end
end
