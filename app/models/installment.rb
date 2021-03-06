class Installment < ActiveRecord::Base

  include Paperclip::Glue

  belongs_to :launch
  belongs_to :installmentable, polymorphic: true
  belongs_to :category
  belongs_to :user
  belongs_to :group
  belongs_to :parent_launch_group, class_name: "Launch"

  validates :value, :date, :number_installment, :launch, :user, presence: true
  validates :value, numericality: true
  validates :number_installment, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :validate_mandatory_updates_group

  has_attached_file :proof, styles: { small: "64x64", med: "100x100", large: "200x200" }
  validates_attachment :proof, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  enum launch_type: %w(expense income)
  enum update_options: %w(only_this update_future all_update)
  enum cancel_options: %w(cancel_this cancel_future cancel_all)

  attr_accessor :update_option, :cancel_option

  def validate_mandatory_updates_group
    if paid.eql?(true) and category.blank? and global_installmentable.blank?
      errors.add(:category, I18n.t('errors.messages.cant_be_blank'))
      errors.add(:global_installmentable, I18n.t('errors.messages.cant_be_blank'))
    end
  end

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
    launch = self.group.present? ? self.parent_launch_group : self.launch
    launch.title = self.title
    launch.description = self.description
    launch.value = self.value
    launch.date = self.date
    launch.launchable = self.installmentable
    launch.launch_type = self.launch_type
    launch.category = self.category
    launch.save
  end

  def update_installments(option, user)
    self.search_installments_to_update(option, user).each do |installment|
      date_installment = installment.date
      installment.populate_installment(self.user, date_installment)
      date_installment = launch.current_date_installment(date_installment)
    end
  end

  def search_installments_to_update(option, user)
    if option.eql?('update_future')
      self.search_greater_than_installment(user)
    elsif option.eql?('all_update')
      self.search_current_intallments(user)
    end
  end

  def search_current_intallments(user)
    self.launch.installments.where(user: user).order(:number_installment)
  end

  def search_greater_than_installment(user)
    self.search_current_intallments(user).where("number_installment >= ?", self.number_installment)
  end

  def populate_installment(user, date_installment, index=nil)
    launch = self.group.present? ? self.parent_launch_group : self.launch
    value = self.persisted? ? launch.value : launch.calculate_user_value

    self.title = launch.title
    self.description = launch.description
    self.value = value
    self.date = date_installment
    self.launch_type = launch.launch_type
    self.number_installment ||= index
    
    if user.eql?(launch.user)
      self.paid = launch.date.eql?(date_installment) ? launch.paid : false
      self.installmentable = launch.launchable
      self.category = launch.category
    end

    self.user = user
    self.group = launch.group
    self.save
  end
  
  def self.sum_of_values(installments)
    - installments.where(launch_type: 0).sum(:value) + installments.where(launch_type: 1).sum(:value)
  end

  def self.to_csv
    attributes = %w{user title description value date paid category}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |inst|
        csv << [inst.user.name, inst.title, inst.description, inst.value, inst.date, inst.paid, inst.category.try(:title)]
      end
    end
  end

  def self.notify_user_to_installment_due
    Installment.installment_due.each do |installment|
      installment.notify_user
      UserMailer.notify_user_to_installment_due(installment).deliver_now!
    end
  end

  def self.installment_due
    Installment.where(launch_type: 'expense', paid: false, date: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  def notify_user
    Notification.create(
      user: self.user,
      title: I18n.t('models.notification.title_installment'), 
      description: I18n.t('models.notification.description_installment', title: self.title, value: ActionController::Base.helpers.number_to_currency(self.value)), 
      icon: 'money' )
  end

  def self.search(options = {})
    scope = all
    scope = scope.where(date: (options[:start_date].to_datetime)..(options[:end_date].to_datetime)) if options[:start_date].present? and options[:end_date].present?
    scope = scope.where("title like ?", "%#{options[:title]}%") if options[:title].present?
    scope = scope.where(category_id: options[:category_id]) if options[:category_id].present?
    scope = scope.where(group_id: options[:group_id]) if options[:group_id].present?
    scope = scope.where(installmentable_id: options[:card_id], installmentable_type: 'Card') if options[:card_id].present?
    scope = scope.where(installmentable_id: options[:account_id], installmentable_type: 'Account') if options[:account_id].present?

    if options[:expense].present? and options[:income].present?
      scope = scope
    elsif options[:expense].present?
      scope = scope.where(launch_type: 0)
    elsif options[:income].present?
      scope = scope.where(launch_type: 1)
    end
    
    scope
  end

end

