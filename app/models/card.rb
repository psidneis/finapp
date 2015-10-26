class Card < ActiveRecord::Base

  has_many :launches, as: :launchable
  belongs_to :account

  # enum brand: {0: 'MasterCard', 1: 'Visa', 2: 'Elo', 3: 'Outros'}

end
