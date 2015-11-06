class InstallmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_installment, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :new, :create]

  respond_to :html

  def index
    @installments = policy_scope(Installment)
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
      @installment.update_parent_launch
      @installment.check_installments_to_update(installment_params[:update_option]) 
    end
    respond_with(@installment)
  end

  def destroy
    @installment.destroy
    respond_with(@installment)
  end

  private
    def set_installment
      @installment = Installment.find(params[:id])
      authorize @installment
    end

    def installment_params
      params.require(:installment).permit(:title, :description, :value, :date, :paid, :launch_type, :category_id, :global_installmentable, :update_option)
    end
end
