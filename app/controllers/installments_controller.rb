class InstallmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_installment, only: [:show, :edit, :update, :destroy, :cancel]
  before_action :set_launch, only: [:index]
  after_action :verify_authorized, except: [:index, :new, :create]

  respond_to :html, :js, :json

  def index
    @installments = policy_scope(Installment)
    @installments = @installments.where(launch: @launch)
    respond_with(@installments)
  end

  def show
    respond_with(@installment)
  end

  def new
    @installment = Installment.new
    respond_with(@installment)
  end

  def edit
  end

  def create
    @installment = Installment.new(installment_params)
    @installment.save
    respond_with(@installment)
  end

  def update
    @installment.update(installment_params)
    if installment_params[:update_option] != 'only_this'
      @installment.update_parent_launch_group
      @installment.check_installments_to_update(installment_params[:update_option], current_user) 
    end
    respond_with(@installment, location: home_dashboard_path)
  end

  def destroy
    if params[:cancel_this].present?
      @installment.destroy
    else
      cancel_option = installment_params[:cancel_option] 
      launch = @installment.launch
      if cancel_option.eql?('cancel_this') or cancel_option.blank?
        @installment.destroy
      elsif cancel_option.eql?('cancel_future')
        launch.update_attributes(enabled: false)
        launch.installments.where("date >= ?", @installment.date).destroy_all
      elsif cancel_option.eql?('cancel_all')
        launch.destroy
      end
    end
    respond_with(@installment, location: home_dashboard_path)
  end

  def cancel
    respond_with(@installment)
  end

  private
    def set_installment
      @installment = Installment.find(params[:id])
      authorize @installment
    end

    def installment_params
      params.require(:installment).permit(:title, :description, :value, :date, :paid, :launch_type, :category_id, :global_installmentable, :update_option, 
        :cancel_option, :group_id)
    end

    def set_launch
      @launch = Launch.find(params[:launch_id])
    end
end
