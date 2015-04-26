class CreateUserVotes < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
      t.boolean :positive
      t.references :user
      t.references :votable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
