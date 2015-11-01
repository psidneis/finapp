class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :new, :create]

  respond_to :html

  def index
    @cards = policy_scope(Card)
    respond_with(@cards)
  end

  def show
    respond_with(@card)
  end

  def new
    @card = Card.new
    respond_with(@card)
  end

  def edit
  end

  def create
    @card = Card.new(card_params)
    @card.user = current_user
    @card.save
    respond_with(@card)
  end

  def update
    @card.update(card_params)
    respond_with(@card)
  end

  def destroy
    @card.destroy
    respond_with(@card)
  end

  private
    def set_card
      @card = Card.find(params[:id])
      authorize @card
    end

    def card_params
      params.require(:card).permit(:brand, :title, :credit_limit, :billing_day, :payment_day, :account_id)
    end
end
