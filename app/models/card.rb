class Card < ActiveRecord::Base

  has_many :launches, as: :launchable
  has_many :installments, as: :installmentable
  has_many :invoices, dependent: :destroy
  belongs_to :account
  belongs_to :user

  validates :brand, :title, :credit_limit, :billing_day, :payment_day, presence: true
  validates :title, uniqueness: { scope: :user_id }, length: { in: 2..100 }
  validates :credit_limit, numericality: true
  validates :billing_day, :payment_day, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }

  enum brand: %w(mastercard visa america_express diners aura elo hipercard others)

  def credit_limit= credit_limit
    if credit_limit =~ /^R\$ ([\d.,]+)$/
      write_attribute :credit_limit, $1.gsub('.', '').gsub(',', '.').to_d
    else
      write_attribute :credit_limit, credit_limit
    end
  end

  def self.human_model_name
    self.model_name.human
  end

  def create_invoice(installment_date)
    invoice = self.invoices.build
    invoice.value = 0
    if installment_date.day <= self.billing_day 
      invoice.title = "#{I18n.t('activerecord.models.invoice.one')} #{I18n.l(installment_date, format: :long_month_year)} "
      invoice.payment_day = Time.new(installment_date.year, installment_date.month, self.payment_day).end_of_day
    else
      invoice.title = "#{I18n.t('activerecord.models.invoice.one')} #{I18n.l(installment_date + 1.month, format: :long_month_year)} "
      invoice.payment_day = (Time.new(installment_date.year, installment_date.month, self.payment_day) + 1.month).end_of_day
    end
    invoice
  end

  def current_invoice(installment_date=Date.today)
    if installment_date.day <= self.billing_day 
      self.invoices.where(payment_day: Time.new(installment_date.year, installment_date.month, self.payment_day).end_of_day).first
    else
      self.invoices.where(payment_day: (Time.new(installment_date.year, installment_date.month, self.payment_day) + 1.month).end_of_day).first
    end
  end
  
  def self.sum_of_cards_invoices(cards)
    total_cards_invoices = 0
    cards.each do |card|
      total_cards_invoices += card.current_invoice.try(:value) || 0
    end
    total_cards_invoices
  end

  def update_card(installment, old_installment=nil, action_name)
    if installment.expense?
      invoice = current_invoice(installment.date)
      if action_name == 'create'
        invoice = create_invoice(installment.date) if invoice.nil?
        invoice.value += installment.value
      elsif action_name == 'update'
        invoice.value -= old_installment.value
        invoice.value += installment.value
        invoice.save
      elsif action_name == 'destroy'
        invoice.value -= old_installment.value
      end
      invoice.save
    end
  end


end
