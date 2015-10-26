class CreateLaunches < ActiveRecord::Migration
  def change
    create_table :launches do |t|
      t.string :title
      t.text :description
      t.decimal :value
      t.date :date
      t.boolean :paid
      t.references :launchable, polymorphic: true, index: true
      t.integer :recurrence_type
      t.integer :amount_installment
      t.integer :recurrence
      t.integer :type
      t.references :category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
