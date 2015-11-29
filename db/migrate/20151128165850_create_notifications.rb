class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.text :description
      t.boolean :check, default: false
      t.string :icon

      t.timestamps null: false
    end
  end
end
