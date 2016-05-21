class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.text :description
      t.string :color
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
