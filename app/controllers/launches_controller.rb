class LaunchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_launch, only: [:show, :edit, :update, :destroy, :apportionment]
  after_action :verify_authorized, except: [:index, :new, :create]

  respond_to :html, :js, :json

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
    @launch.user = current_user

    if @launch.save
      @launch.choose_type_launch
      @launch.notify_user_groups
      
      location = @launch.group.present? ? apportionment_launch_path(@launch) : home_dashboard_path
      @launch.update_account
    end

    respond_with(@launch, location: location)
  end

  def update
    @launch.update(launch_params)
    respond_with(@launch, location: launch_installments_path(@launch))
  end

  def destroy
    @launch.destroy
    respond_with(@launch)
  end

  def apportionment
    @search_period = params[:search_period].try(:to_date) || @launch.date
    @apportionments = @launch.installments.where(date: @search_period.beginning_of_month..@search_period.end_of_month).order(:date)
  end

  private
    def set_launch
      @launch = Launch.find(params[:id])
      authorize @launch
    end

    def launch_params
      params.require(:launch).permit(:title, :description, :value, :date, :paid, :recurrence_type, :amount_installment, :recurrence, :launch_type, :category_id, 
        :group_id, :global_launchable, installments_attributes: [:id, :value] )
    end
end
