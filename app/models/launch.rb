class Launch < ActiveRecord::Base

  has_many :installments, dependent: :destroy

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
    total_installments = self.recurrence? ? 31 : self.amount_installment

    for index in 1..total_installments
      if self.group.present?
        self.generate_group_installments(date_installment, index)
      else
        self.generate_installments(date_installment, index)
      end
      date_installment = self.current_date_installment(date_installment)
    end

    self.last_installment_date = self.installments.unscoped.last.date
    self.save
  end

  def generate_installments(date_installment, index)
    installment = self.installments.build
    installment.create_or_update_installment(date_installment, index)
  end

  def generate_group_installments(date_installment, index)
    user_groups = self.available_user_groups
    value_per_user = self.calculate_amount_division_group(user_groups.count)

    parent_launch_group ||= self.dup
    
    user_groups.each do |user_group|
      parent_launch_group = user_group.user
      parent_launch_group.save

      installment = self.installments.build
      installment.title = self.title
      installment.description = self.description
      installment.value = value_per_user
      installment.date = date_installment
      installment.launch_type = self.launch_type
      installment.number_installment = index
      if self.user.eql?(user_group.user)
        installment.paid = self.date.eql?(date_installment) ? self.paid : false
        installment.installmentable = self.launchable
        installment.category = self.category
      end
      installment.user = user_group.user
      installment.group = self.group

      parent_launch_group ||= self.dup
      parent_launch_group.user = user_group.user
      installment.parent_launch_group = parent_launch_group
      installment.save
    end
  end

  def calculate_amount_division_group(total_user_group)
    self.value / total_user_group
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
        launch.choose_type_launch(date_installment)
      end
    end
  end

  def notify_user_groups
    user_groups = self.available_user_groups
    value_per_user = self.calculate_amount_division_group(user_groups.count)

    user_groups.each do |user_group|
      if self.user != user_group.user
        note = self.recurrence? ? t('activerecord.attributes.launch.recurrence_types.recurrence') : "#{self.amount_installment} x 
          #{ActionController::Base.helpers.number_to_currency(value_per_user)}"

        Notification.create(
          user: user_group.user,
          title: I18n.t('models.notification.title_launch_group'), 
          description: I18n.t('models.notification.description_launch_group', note: note), 
          icon: 'calendar' )
      end
    end
  end

  def available_user_groups
    self.group.user_groups.where(enabled: true)
  end

  def update_account
    account = self.launchable
    if self.income?
      account.value += self.value
    else
      account.value -= self.value
    end
    account.save
  end

end