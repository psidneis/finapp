class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :brand
      t.string :title
      t.decimal :credit_limit, default: 0.0, precision: 15, scale: 2
      t.integer :billing_day
      t.integer :payment_day
      t.decimal :bill, default: 0.0, precision: 15, scale: 2
      t.references :account, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
