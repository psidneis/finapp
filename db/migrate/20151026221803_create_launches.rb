class CreateLaunches < ActiveRecord::Migration
  def change
    create_table :launches do |t|
      t.string :title
      t.text :description
      t.decimal :value
      t.datetime :date
      t.boolean :paid
      t.references :launchable, polymorphic: true, index: true
      t.integer :recurrence_type, default: 0
      t.integer :amount_installment, default: 1
      t.integer :recurrence, default: 4
      t.integer :launch_type
      t.datetime :last_installment_date
      t.datetime :enabled, default: 1
      t.references :category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
