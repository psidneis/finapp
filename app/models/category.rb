class Category < ActiveRecord::Base

  has_many :launches
  has_many :installments
  has_one :goal
  belongs_to :user

  validates :title, presence: true, uniqueness: { scope: :user_id }, length: { in: 2..100 }

  def calculate_total_period(user, date)
    start_date = date.beginning_of_month
    end_date = date.end_of_month

    self.installments.where(user: user, date: start_date..end_date).sum(:value)
  end

  def percentage_period(total, total_category)
    (total_category*100)/total
  end

end
