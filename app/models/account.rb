class Account < ActiveRecord::Base

  has_many :launches, as: :launchable
  belongs_to :user

  enum account_type: %w(wallet checking_account savings_account)

  def self.human_model_name
    self.model_name.human
  end

end
