class UserGroup < ActiveRecord::Base

  belongs_to :group
  belongs_to :user

  # enum role: {0: 'Administrador', 1: 'Lançador', 2: 'Visualizador'}

end
