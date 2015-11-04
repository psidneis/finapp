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

  def generate_installments(options={})
    date_installment = self.date
    for i in 1..self.amount_installment
      installment = self.installments.build
      installment.date = date_installment
      installment.value = self.value
      installment.number_installment = i
      installment.paid = i.eql?(1) ? self.paid : false
      installment.save
      date_installment = self.current_date_installment(date_installment)
    end
  end

  def current_date_installment(date_installment)
    recurrence = {
      yearly: {count: 1, period: :year}, 
      biannual: {count: 6, period: :months}, 
      quarterly: {count: 3, period: :months}, 
      bimonthly: {count: 2, period: :months}, 
      monthly: {count: 1, period: :month}, 
      fortnightly: {count: 15, period: :days}, 
      weekly: {count: 1, period: :week}, 
      daily: {count: 1, period: :day}
    }

    recurrence = recurrence[self.recurrence.to_sym]
    date_installment + recurrence[:count].send(recurrence[:period])
  end

end