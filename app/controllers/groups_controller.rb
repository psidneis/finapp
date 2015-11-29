class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :dashboard]
  after_action :verify_authorized, except: [:index, :new, :create, :dashboard]
  before_action :get_period_installments, only: [:dashboard]

  respond_to :html, :json, :js

  def index
    @groups = policy_scope(Group)
    respond_with(@groups)
  end

  def show
    respond_with(@group)
  end

  def new
    @group = Group.new
    respond_with(@group)
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    @group.user_groups.build(user: current_user, email: current_user.email, role: 'admin', enabled: true)
    @group.save
    respond_with(@group, location: group_user_groups_path(@group))
  end

  def update
    @group.update(group_params)
    respond_with(@group, location: group_user_groups_path(@group))
  end

  def destroy
    @group.destroy
    respond_with(@group)
  end

  def dashboard
    Launch.generate_recurrence_launches(current_user, @search_period)

    @installments = @group.installments
    @installments = @installments.where(date: @start_date..@end_date).order(:date)

    respond_with(@installments)
  end

  private
    def set_group
      @group = Group.find(params[:id])
      authorize @group
    end

    def group_params
      params.require(:group).permit(:title, :description)
    end

    def get_period_installments
      @search_period_type = params[:search_period_type] || 'month'
      @search_period = params[:search_period].try(:to_time) || DateTime.now
      @start_date = params[:start_date].try(:to_time) || @search_period.send("beginning_of_#{@search_period_type}")
      @end_date = params[:end_date].try(:to_time) || @search_period.send("end_of_#{@search_period_type}")
    end
end
