class Account < ActiveRecord::Base

  has_many :launches, as: :launchable
  has_many :installments, as: :installmentable
  has_many :cards
  belongs_to :user

  validates :account_type, :title, :value, presence: true
  validates :title, uniqueness: { scope: :user_id }, length: { in: 2..100 }
  validates :value, numericality: true

  enum account_type: %w(wallet checking_account savings_account)

  def value= value
    if value =~ /^R\$ ([\d.,]+)$/
      write_attribute :value, $1.gsub('.', '').gsub(',', '.').to_d
    else
      write_attribute :value, value
    end
  end

  def self.human_model_name
    self.model_name.human
  end

  def self.sum_of_values(accounts)
    accounts.sum(:value)
  end

  def self.sum_of_values_by_period(accounts, end_date)
    total_value = 0
    accounts.each do |account|
      total_value += account.total_value_by_period(end_date)
    end
    total_value
  end

  def self.sum_of_future_values(accounts)
    # total_value = 0
    # accounts.each do |account|
    #   total_value += account.total_future_value if account.cards.present?
    # end
    # total_value
  end

  def total_value_by_period(end_date)
    (self.value + self.installments.where("date > ? and paid", end_date).sum(:value)) unless self.created_at > end_date
  end

  def total_future_value
    # if self.cards.present?
    #   cards = self.cards
    #   billing_day = Time.local(Time.now.year, Time.now.month, self.cards.first.billing_day).end_of_day
    #   (self.value - installment.joins(:cards).where("date < ? and not paid", billing_day).sum(:value))
    #   # (self.value - self.installments.where("date < ? and not paid", billing_day).sum(:value))
    # end
  end

  def update_account(installment, old_installment=nil, action_name)
    if installment.expense?
      if action_name == 'create'
        self.value -= installment.value if installment.paid?
      elsif action_name == 'update'
        calculate_account_on_expense_update(installment, old_installment)
      elsif action_name == 'destroy'
        self.value += old_installment.value if installment.paid?
      end
    else
      if action_name == 'create'
        self.value += installment.value if installment.paid?
      elsif action_name == 'update'
        calculate_account_on_income_update(installment, old_installment)
      elsif action_name == 'destroy'
        self.value -= old_installment.value
      end
    end
    self.save
  end

  def calculate_account_on_expense_update(installment, old_installment)
    if installment.paid?
      if old_installment.paid?
        self.value += old_installment.value
      end
      self.value -= installment.value
    else
      if old_installment.paid?
        self.value += old_installment.value
      end 
    end
  end

  def calculate_account_on_income_update(installment, old_installment)
    if installment.paid?
      if old_installment.paid?
        self.value -= old_installment.value
      end
      self.value += installment.value
    else
      if old_installment.paid?
        self.value -= old_installment.value
      end 
    end
  end

end
