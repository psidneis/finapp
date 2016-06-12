class Invoice < ActiveRecord::Base

	belongs_to :card

	validates :title, :payment_day, presence: true
  validates :title, length: { in: 2..100 }
  validates :value, numericality: true

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

  def installments
    card = self.card
    invoice_period =  (Time.new(self.payment_day.year, self.payment_day.month, card.billing_day) - (1.month - 1.day)).beginning_of_day..(Time.new(self.payment_day.year, self.payment_day.month, card.billing_day).end_of_day)
    self.card.installments.where(date: invoice_period)
  end

end
