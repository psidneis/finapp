class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.boolean :enabled, default: 0
      t.integer :role, default: 1
      t.references :group, index: true
      t.references :user, index: true
      t.string :email, null: false, default: ""

      t.timestamps null: false
    end
  end
end
