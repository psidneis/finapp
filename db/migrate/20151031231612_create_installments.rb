class CreateInstallments < ActiveRecord::Migration
  def change
    create_table :installments do |t|
      t.string :title
      t.text :description
      t.decimal :value, default: 0.0, precision: 15, scale: 2
      t.datetime :date
      t.boolean :paid, default: false
      t.integer :launch_type
      t.integer :number_installment
      t.references :installmentable, polymorphic: true
      t.references :category, index: true
      t.references :user, index: true
      t.references :launch, index: true
      t.references :group, index: true
      t.references :parent_launch_group, index: true
      t.attachment :proof

      t.timestamps null: false
    end
  end
end
