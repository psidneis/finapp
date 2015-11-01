class LaunchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_launch, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :new, :create]

  respond_to :html

  def index
    @launches = policy_scope(Launch)
    respond_with(@launches)
  end

  def show
    respond_with(@launch)
  end

  def new
    @launch = Launch.new
    respond_with(@launch)
  end

  def edit
  end

  def create
    @launch = Launch.new(launch_params)
    @launch.save
    respond_with(@launch)
  end

  def update
    @launch.update(launch_params)
    respond_with(@launch)
  end

  def destroy
    @launch.destroy
    respond_with(@launch)
  end

  private
    def set_launch
      @launch = Launch.find(params[:id])
      authorize @launch
    end

    def launch_params
      params.require(:launch).permit(:title, :description, :value, :date, :paid, :launchable_id, :launchable_type, :recurrence_type, :amount_installment, :recurrence, :launch_type, :category_id, :user_id)
    end
end
