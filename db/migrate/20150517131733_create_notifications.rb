class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :question, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :notifications, :questions
    add_foreign_key :notifications, :users

    add_index :notifications, [:question_id, :user_id]
  end
end
