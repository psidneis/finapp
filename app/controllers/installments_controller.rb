class InstallmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_installment, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: :index

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
      params.require(:installment).permit(:value, :date, :paid, :number_installment, :launch_id)
    end
end
