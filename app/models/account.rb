class Account < ActiveRecord::Base

  has_many :launches, as: :launchable
  belongs_to :user

  enum type: {0: 'Carteira', 1: 'Corrente', 2: 'Poupança'}

end
