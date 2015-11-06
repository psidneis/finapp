class Card < ActiveRecord::Base

  has_many :launches, as: :launchable
  has_many :installments, as: :installmentable
  belongs_to :account
  belongs_to :user

  validates :brand, :title, :credit_limit, :billing_day, :payment_day, presence: true
  validates :title, uniqueness: { scope: :user_id }, length: { in: 2..100 }
  validates :credit_limit, numericality: { greater_than_or_equal_to: 0}
  validates :billing_day, :payment_day, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }

  enum brand: %w(mastercard visa america_express diners aura elo hipercard others)

  def self.human_model_name
    self.model_name.human
  end

end
