class Launch < ActiveRecord::Base

  belongs_to :launchable, polymorphic: true
  belongs_to :category
  belongs_to :user

  enum recurrence_type: %w(not_recurrence installments recurrence)
  enum recurrence: %w(yearly biannual quarterly bimonthly monthly fortnightly weekly daily)
  enum launch_type: %w(expense income)

end
