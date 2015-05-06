class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end
    add_foreign_key :authentications, :users
    add_index :authentications, [:provider, :uid]
  end
end
