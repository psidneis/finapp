class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.boolean :enabled, default: 1
      t.integer :role, default: 1
      t.references :group, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :email, null: false, default: ""

      t.timestamps null: false
    end
  end
end
