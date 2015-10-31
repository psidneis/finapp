class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.decimal :value
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
