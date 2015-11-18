class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :get_period_installments, only: [:dashboard, :calendar, :report, :chart]
	
	respond_to :html, :json
  	
  def index
  	redirect_to new_user_session_path unless user_signed_in?
  end

  def dashboard
    Launch.generate_recurrence_launches(current_user, @search_period)
    @accounts = policy_scope(Account)

    respond_with(@installments)
  end

  def calendar

    respond_with(@installments)
  end

  def report

    respond_with(@installments)
  end

  def chart
    @total_period = @installments.sum(:value)
    @categories = @installments.select("categories.title, categories.color, sum(value) as total_category")
      .joins(:category).group(:category_id).where(launch_type: 'expense')

    respond_with(@categories)
  end

  private

    def get_period_installments
      @search_period = params[:search_period].try(:to_date) || Date.today
      @start_date = params[:start_date].try(:to_date) || @search_period.beginning_of_month
      @end_date = params[:end_date].try(:to_date) || @search_period.end_of_month

      @installments = policy_scope(Installment)
      @installments = @installments.where(date: @start_date..@end_date).order(:date)
    end

end
