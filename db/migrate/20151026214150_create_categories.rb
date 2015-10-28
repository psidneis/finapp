class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.text :description
      t.string :color
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
