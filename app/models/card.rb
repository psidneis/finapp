class Card < ActiveRecord::Base

  has_many :launches, as: :launchable
  has_many :installments, as: :installmentable
  has_many :invoices
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

  def create_invoice
    invoice = self.invoices.build
    invoice.title = "#{I18n.t('activerecord.models.invoice.one')} #{I18n.l(Date.today, format: :long_month_year)} "
    invoice.value = 0
    invoice.payment_day = Time.new(Time.now.year, Time.now.month, self.payment_day).end_of_day
    invoice
  end

  def current_invoice
    self.invoices.where(payment_day: Time.new(Time.now.year, Time.now.month, self.payment_day).end_of_day).first
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
      invoice = current_invoice
      if action_name == 'create'
        invoice = create_invoice if invoice.nil?
        invoice.value += installment.value

        self.bill -= installment.value
      elsif action_name == 'update'
        # calculate_account_on_expense_update(installment, old_installment)
        invoice.save
      elsif action_name == 'destroy'
        invoice.value -= old_installment.value
      end
      invoice.save
    end
  end


end
