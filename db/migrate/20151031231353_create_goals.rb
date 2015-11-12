class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.decimal :value, default: 0.0, precision: 15, scale: 2
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
