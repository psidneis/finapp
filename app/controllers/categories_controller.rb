class CategoriesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: :index

  respond_to :html

  def index
    @categories = policy_scope(Category)
    respond_with(@categories)
  end

  def show
    respond_with(@category)
  end

  def new
    @category = Category.new
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    @category.save
    respond_with(@category)
  end

  def update
    @category.update(category_params)
    respond_with(@category)
  end

  def destroy
    @category.destroy
    respond_with(@category)
  end

  private
    def set_category
      @category = Category.find(params[:id])
      authorize @category
    end

    def category_params
      params.require(:category).permit(:title, :description, :color)
    end
end
