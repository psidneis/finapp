class Launch < ActiveRecord::Base

  belongs_to :launchable, polymorphic: true
  belongs_to :category
  belongs_to :user

  # enum recurrence_type: {:installments, :recurrence, :not_recurrence}
  enum recurrence: %w(yearly biannual quarterly bimonthly monthly fortnightly weekly daily)
  # enum type: {0: 'Receita', 1: 'Despesa'}

end
