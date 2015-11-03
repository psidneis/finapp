class Launch < ActiveRecord::Base

  has_many :installments
  belongs_to :launchable, polymorphic: true
  belongs_to :category
  belongs_to :user
  belongs_to :group

  validates :title, :value, :date, :recurrence_type, :recurrence, :launch_type, :category, presence: true
  validates :title, length: { in: 2..100 }
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  validates :amount_installment, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  enum recurrence_type: %w(not_recurrence installments recurrence)
  enum recurrence: %w(yearly biannual quarterly bimonthly monthly fortnightly weekly daily)
  enum launch_type: %w(expense income)

  def global_launchable
    self.launchable.to_global_id if self.launchable.present?
  end

  def global_launchable=(launchable)
    self.launchable = GlobalID::Locator.locate launchable
  end

end