class Account < ActiveRecord::Base

  has_many :launches, as: :launchable
  belongs_to :user

  validates :account_type, :title, :value, presence: true
  validates :title, uniqueness: { scope: :user_id }, length: { in: 2..100 }
  validates :value, numericality: true

  enum account_type: %w(wallet checking_account savings_account)

  def self.human_model_name
    self.model_name.human
  end

end
