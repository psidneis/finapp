class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show]
  after_action :verify_authorized, only: :show

  respond_to :html

  def index
    @users = policy_scope(User)
    respond_with(@users)
  end

  def show
    respond_with(@user)
  end

  private
    def set_user
      @user = User.find(params[:id])
      authorize @category
    end

end
