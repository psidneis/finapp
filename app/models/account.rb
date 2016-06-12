class Account < ActiveRecord::Base

  has_many :launches, as: :launchable
  has_many :installments, as: :installmentable
  has_many :cards
  belongs_to :user

  validates :account_type, :title, :value, presence: true
  validates :title, uniqueness: { scope: :user_id }, length: { in: 2..100 }
  validates :value, numericality: true

  enum account_type: %w(wallet checking_account savings_account)

  attr_accessor :modal

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

  def self.sum_of_values
    all.sum(:value)
  end

  def self.sum_of_values_by_period(end_date)
    total_value = 0
    all.each do |account|
      total_value += account.total_value_by_period(end_date) || 0
    end
    total_value
  end

  def total_value_by_period(end_date)
    self.value + self.installments.where("date > ? and paid = ?", end_date, true).sum(:value) if end_date < self.created_at
  end

  def self.sum_of_future_values(search_period_type)
    total_value = 0
    all.each do |account|
      total_value += account.total_future_value(search_period_type)
    end
    total_value
  end

  def total_future_value(search_period_type)
    value_to_pay = 0
    self.cards.each do |card|
      value_to_pay += card.current_invoice.try(:value) || 0 unless card.current_invoice.try(:paid)
    end
    value_to_pay += self.installments.where(date: (Date.today.send("beginning_of_#{search_period_type}")..Date.today.send("end_of_#{search_period_type}")), paid: false).sum(:value)
    self.value - value_to_pay
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
