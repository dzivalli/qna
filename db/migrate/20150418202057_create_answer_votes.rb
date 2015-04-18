class CreateAnswerVotes < ActiveRecord::Migration
  def change
    create_table :answer_votes do |t|
      t.references :answer
      t.references :user

      # +: true, -: false
      t.boolean :positive

      t.timestamps null: false
    end
    add_foreign_key :answer_votes, :answers
    add_foreign_key :answer_votes, :users

    add_index :answer_votes, [:answer_id, :user_id]
  end
end
