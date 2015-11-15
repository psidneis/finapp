class Account < ActiveRecord::Base

  has_many :launches, as: :launchable
  has_many :installments, as: :installmentable
  belongs_to :user

  validates :account_type, :title, :value, presence: true
  validates :title, uniqueness: { scope: :user_id }, length: { in: 2..100 }
  validates :value, numericality: true

  enum account_type: %w(wallet checking_account savings_account)

  def self.human_model_name
    self.model_name.human
  end

  def self.sum_of_values 
    Account.sum(:value)
  end

end
