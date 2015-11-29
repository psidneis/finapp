class Launch < ActiveRecord::Base

  has_many :installments, dependent: :destroy
  has_many :parent_launch_groups, foreign_key: "parent_launch_group_id", class_name: 'Installment'

  belongs_to :launchable, polymorphic: true
  belongs_to :category
  belongs_to :user
  belongs_to :group

  validates :title, :value, :date, :recurrence_type, :recurrence, :launch_type, :category, presence: true
  validates :title, length: { in: 2..100 }
  validates :value, numericality: true
  validates :amount_installment, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  accepts_nested_attributes_for :installments

  enum recurrence_type: %w(not_recurrence installments recurrence)
  enum recurrence: %w(yearly biannual quarterly bimonthly monthly fortnightly weekly daily)
  enum launch_type: %w(expense income)

  def value= value
    if value =~ /^R\$ ([\d.,]+)$/
      write_attribute :value, $1.gsub('.', '').gsub(',', '.').to_d
    else
      write_attribute :value, value
    end
  end

  def global_launchable
    self.launchable.to_global_id if self.launchable.present?
  end

  def global_launchable=(launchable)
    self.launchable = GlobalID::Locator.locate launchable
  end

  def choose_type_launch(current_date = nil)
    date_installment = current_date || self.date
    self.group.blank? ? self.user_installments(date_installment) : self.group_installments(date_installment)
  end

  def user_installments(date_installment)
    date_installment = self.build_installment(self.user, date_installment)
  end

  def group_installments(date_installment)
    self.available_user_groups.each do |user_group|
      parent_launch_group = self.generate_parent_launch_group(user_group.user)
      date_installment = self.date
      self.build_installment(user_group.user, date_installment, parent_launch_group)
    end
  end

  def generate_parent_launch_group(user)
    parent_launch_group = self.dup
    parent_launch_group.user = user
    parent_launch_group.save
    parent_launch_group
  end

  def total_installments
    self.recurrence? ? 31 : self.amount_installment
  end

  def build_installment(user, date_installment, parent_launch_group=nil)
    for index in 1..self.total_installments
      installment = self.installments.build
      installment.parent_launch_group = parent_launch_group
      installment.populate_installment(user, date_installment, index)
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

  def update_last_installment
    self.update_attribute(:last_installment_date, self.installments.unscoped.last.date)
  end

  def notify_user_groups
    self.available_user_groups.each do |user_group|
      if self.user != user_group.user
        Notification.create(
          user: user_group.user,
          title: I18n.t('models.notification.title_launch_group'), 
          description: I18n.t('models.notification.description_launch_group', note: self.note_to_user_notification), 
          icon: 'calendar' )
      end
    end
  end

  def note_to_user_notification
    if self.recurrence?
      t('activerecord.attributes.launch.recurrence_types.recurrence')
    else
      "#{self.amount_installment} x #{ActionController::Base.helpers.number_to_currency(self.calculate_user_value)}"
    end
  end

  def available_user_groups
    self.group.user_groups.where(enabled: true)
  end

  def calculate_user_value
    if self.group.present?
      self.value / self.available_user_groups.count
    else
      self.value
    end
  end

  def self.generate_recurrence_launches(user, period)
    user.current_recurrence_launches.each do |launch|
      if launch.last_installment_date <= period.end_of_month
        date_installment = launch.current_date_installment(launch.last_installment_date)
        launch.choose_type_launch(date_installment)
      end
    end
  end

  def update_account
    # account = self.launchable
    # if self.income?
    #   account.value += self.value
    # else
    #   account.value -= self.value
    # end
    # account.save
  end

end