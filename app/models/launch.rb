class Launch < ActiveRecord::Base

  belongs_to :launchable, polymorphic: true
  belongs_to :category
  belongs_to :user

  # enum recurrence_type: {:installments, :recurrence, :not_recurrence}
  # enum recurrence: {0: 'Anual', 1: 'Semestral', 2: 'Trimestral', 3: 'Bimestral', 4: 'Mensal', 5: 'Quinzenal', 6: 'Semanal', 7: 'Diária'}
  # enum type: {0: 'Receita', 1: 'Despesa'}

end
