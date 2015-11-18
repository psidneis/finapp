class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard, :calendar, :report, :chart]
	
	respond_to :html, :json
  	
  def index
  	redirect_to new_user_session_path unless user_signed_in?
  end

  def dashboard
    @search_period_type = params[:search_period_type] || 'month'
    @search_period = params[:search_period].try(:to_datetime) || DateTime.now
    Launch.generate_recurrence_launches(current_user, @search_period)
    @accounts = policy_scope(Account)
    @installments = policy_scope(Installment)

    # start_date = params[:start_date].try(:to_date) || @search_period.beginning_of_month
    @start_date = params[:start_date].try(:to_datetime) || @search_period.send("beginning_of_#{@search_period_type}")
    # end_date = params[:end_date].try(:to_date) || @search_period.end_of_month
    @end_date = params[:end_date].try(:to_datetime) || @search_period.send("end_of_#{@search_period_type}")

    @installments = @installments.where(date: @start_date..@end_date).order(:date)

    respond_with(@installments)
  end

  def calendar

  end

  def report

  end

  def chart
    @search_period = params[:search_period].try(:to_date) || Date.today
    start_date = params[:start_date].try(:to_date) || @search_period.beginning_of_month
    end_date = params[:end_date].try(:to_date) || @search_period.end_of_month

    @categories = policy_scope(Category)
    @total_period = @categories.joins(:installments).where("installments.user_id = ? and installments.date between ? and ?", current_user.id, start_date, end_date).sum('installments.value')

    respond_with(@categories)
  end

end
