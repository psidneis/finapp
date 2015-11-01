class Launch < ActiveRecord::Base

  has_many :installments
  belongs_to :launchable, polymorphic: true
  belongs_to :category
  belongs_to :user
  belongs_to :group

  validates :title, :value, :date, :launchable, :recurrence_type, :recurrence, :launch_type, :category, presence: true
  validates :title, length: { in: 2..100 }
  validates :value, numericality: true
  validates :amount_installment, numericality: { only_integer: true }

  enum recurrence_type: %w(not_recurrence installments recurrence)
  enum recurrence: %w(yearly biannual quarterly bimonthly monthly fortnightly weekly daily)
  enum launch_type: %w(expense income)

end
