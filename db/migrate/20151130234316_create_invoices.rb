class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :title, null: false
      t.string :description
      t.decimal :value, null: false, default: 0.0, precision: 15, scale: 2
      t.references :card, index: true
      t.datetime :payment_day, null: false
      t.boolean :paid, default: 0

      t.timestamps null: false
    end
  end
end
