class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show]

  respond_to :html

  def index
    @users = User.all
    respond_with(@users)
  end

  def show
    respond_with(@user)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

end
