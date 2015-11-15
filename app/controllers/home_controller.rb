class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
	
	respond_to :html, :json
  	
  def index
  	redirect_to new_user_session_path unless user_signed_in?
  end

  def dashboard
    @search_period = params[:search_period].try(:to_date) || Date.today
    Launch.generate_recurrence_launches(current_user, @search_period)
    @accounts = policy_scope(Account)
    @installments = policy_scope(Installment)
    @installments = @installments.where(date: @search_period.beginning_of_month..@search_period.end_of_month).order(:date)

    respond_with(@accounts, @installments)
  end
end
