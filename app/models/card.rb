class Card < ActiveRecord::Base

  has_many :launches, as: :launchable
  belongs_to :account
  belongs_to :user

  validates :brand, :title, :credit_limit, :billing_day, :payment_day, presence: true
  validates :title, uniqueness: { scope: :user_id }, length: { in: 2..100 }
  validates :credit_limit, numericality: true
  validates :billing_day, :payment_day, numericality: { only_integer: true }

  enum brand: %w(mastercard visa america_express diners aura elo hipercard others)

  def self.human_model_name
    self.model_name.human
  end

end
