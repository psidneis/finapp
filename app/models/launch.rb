class Launch < ActiveRecord::Base

  has_many :installments, dependent: :destroy
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

  def generate_launch_installments(current_date = nil)
    date_installment = current_date || self.date
    total_installments = self.recurrence? ? 60 : self.amount_installment
    for index in 1..total_installments
      installment = self.installments.build
      installment.create_or_update_installment(date_installment, index)
      self.last_installment_date = installment.date
      date_installment = self.current_date_installment(date_installment)
    end
    self.save
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

  def self.generate_recurrence_launches(user, period)
    Launch.where("user_id = ? and recurrence_type = ? and enabled = ?", user.id, 2, true).each do |launch|
      installment = launch.installments.last
      if launch.last_installment_date <= period.end_of_month
        date_installment = launch.current_date_installment(launch.last_installment_date)
        launch.generate_launch_installments(date_installment)
      end
    end
  end

end