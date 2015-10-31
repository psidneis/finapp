class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @goals = Goal.all
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

  private
    def set_goal
      @goal = Goal.find(params[:id])
    end

    def goal_params
      params.require(:goal).permit(:value, :category_id)
    end
end
