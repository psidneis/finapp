class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :account_type, default: 0
      t.string :title
      t.text :description
      t.decimal :value
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
