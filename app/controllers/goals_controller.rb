class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :new, :create, :chart]
  before_action :get_period_installments, only: [:chart]

  respond_to :html, :js

  def index
    @goals = policy_scope(Goal)
    respond_with(@goals)
  end

  def show
    respond_with(@goal)
  end

  def new
    @goal = Goal.new
    respond_with(@goal)
  end

  def edit
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.save
    respond_with(@goal)
  end

  def update
    @goal.update(goal_params)
    respond_with(@goal)
  end

  def destroy
    @goal.destroy
    respond_with(@goal)
  end

  def chart
    @goals = policy_scope(Goal)
    respond_with(@goals)
  end

  private
    def set_goal
      @goal = Goal.find(params[:id])
      authorize @goal
    end

    def goal_params
      params.require(:goal).permit(:value, :category_id)
    end

    def get_period_installments
      @search_period_type = params[:search_period_type] || 'month'
      @search_period = params[:search_period].try(:to_time) || DateTime.now
      @start_date = params[:start_date].try(:to_time) || @search_period.send("beginning_of_#{@search_period_type}")
      @end_date = params[:end_date].try(:to_time) || @search_period.send("end_of_#{@search_period_type}")
    end
end
