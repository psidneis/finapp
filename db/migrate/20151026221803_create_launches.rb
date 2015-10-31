class CreateLaunches < ActiveRecord::Migration
  def change
    create_table :launches do |t|
      t.string :title
      t.text :description
      t.decimal :value
      t.date :date
      t.references :launchable, polymorphic: true, index: true
      t.integer :recurrence_type, default: 0
      t.integer :amount_installment, default: 1
      t.integer :recurrence, default: 4
      t.integer :launch_type
      t.references :category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
