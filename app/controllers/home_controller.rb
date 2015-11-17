class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard, :calendar]
	
	respond_to :html, :json
  	
  def index
  	redirect_to new_user_session_path unless user_signed_in?
  end

  def dashboard
    @search_period = params[:search_period].try(:to_date) || Date.today
    Launch.generate_recurrence_launches(current_user, @search_period)
    @accounts = policy_scope(Account)
    @installments = policy_scope(Installment)

    start_date = params[:start_date].try(:to_date) || @search_period.beginning_of_month
    end_date = params[:end_date].try(:to_date) || @search_period.end_of_month

    @installments = @installments.where(date: start_date..end_date).order(:date)

    respond_with(@installments)
  end

  def calendar

  end

end
