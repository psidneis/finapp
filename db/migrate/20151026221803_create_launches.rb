class CreateLaunches < ActiveRecord::Migration
  def change
    create_table :launches do |t|
      t.string :title
      t.text :description
      t.decimal :value, default: 0.0, precision: 15, scale: 2
      t.datetime :date
      t.boolean :paid, default: false
      t.references :launchable, polymorphic: true, index: true
      t.integer :recurrence_type, default: 0
      t.integer :amount_installment, default: 1
      t.integer :recurrence, default: 4
      t.integer :launch_type
      t.datetime :last_installment_date
      t.boolean :enabled, default: 1
      t.boolean :enabled, default: 1
      t.attachment :proof
      t.references :category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
