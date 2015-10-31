class CreateInstallments < ActiveRecord::Migration
  def change
    create_table :installments do |t|
      t.decimal :value
      t.date :date
      t.boolean :paid
      t.integer :number_installment
      t.references :launch, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
