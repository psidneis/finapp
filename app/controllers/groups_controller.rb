class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :new, :create]

  respond_to :html

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
    if params[:group][:modal] == 'launch'
      redirect_to new_launch_path
    else
      respond_with(@group, location: group_user_groups_path(@group))
    end
  end

  def update
    @group.update(group_params)
    respond_with(@group, location: group_user_groups_path(@group))
  end

  def destroy
    @group.destroy
    respond_with(@group)
  end

  private
    def set_group
      @group = Group.find(params[:id])
      authorize @group
    end

    def group_params
      params.require(:group).permit(:title, :description)
    end
end
