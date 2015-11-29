class Installment < ActiveRecord::Base

  belongs_to :launch
  belongs_to :installmentable, polymorphic: true
  belongs_to :category
  belongs_to :user

  validates :value, :date, :number_installment, :launch, :user, presence: true
  validates :value, numericality: true
  validates :number_installment, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  enum launch_type: %w(expense income)
  enum update_options: %w(only_this update_future all_update)
  enum cancel_options: %w(cancel_this cancel_future cancel_all)

  attr_accessor :update_option, :cancel_option

  def value= value
    if value =~ /^R\$ ([\d.,]+)$/
      write_attribute :value, $1.gsub('.', '').gsub(',', '.').to_d
    else
      write_attribute :value, value
    end
  end

  def global_installmentable
    self.installmentable.to_global_id if self.installmentable.present?
  end

  def global_installmentable=(installmentable)
    self.installmentable = GlobalID::Locator.locate installmentable
  end

  def update_parent_launch
    launch = self.launch
    launch.title = self.title
    launch.description = self.description
    launch.value = self.value
    launch.date = self.date
    launch.launchable = self.installmentable
    launch.launch_type = self.launch_type
    launch.category = self.category
    launch.save
  end

  def check_installments_to_update(option)
    launch = self.launch
    if option.eql?('update_future')
      installments = launch.installments.where("number_installment >= ?", self.number_installment).order(:number_installment)
    elsif option.eql?('all_update')
      installments = launch.installments.order(:number_installment)
    end

    date_installment = launch.date
    installments.each do |installment|
      installment.create_or_update_installment(date_installment)
      date_installment = launch.current_date_installment(date_installment)
    end
  end

  def create_or_update_installment(date_installment, index=nil, user)
    launch = self.launch

    self.title = launch.title
    self.description = launch.description
    self.value = launch.value
    self.date = date_installment
    self.paid = launch.date.eql?(date_installment) ? launch.paid : false
    self.launch_type = launch.launch_type
    self.number_installment ||= index
    self.installmentable = launch.launchable
    self.category = launch.category
    self.user = user
    self.save
  end
  
  def self.sum_of_values(installments)
    installments.where(launch_type: 0).sum(:value) - installments.where(launch_type: 1).sum(:value)
  end

end

