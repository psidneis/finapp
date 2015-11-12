class CreateInstallments < ActiveRecord::Migration
  def change
    create_table :installments do |t|
      t.string :title
      t.text :description
      t.decimal :value, default: 0.0, precision: 15, scale: 2
      t.datetime :date
      t.boolean :paid
      t.integer :launch_type
      t.integer :number_installment
      t.references :installmentable, polymorphic: true
      t.references :category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :launch, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
