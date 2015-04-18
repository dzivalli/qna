class CreateQuestionVotes < ActiveRecord::Migration
  def change
    create_table :question_votes do |t|
      t.references :question
      t.references :user

      # +: true, -: false
      t.boolean :positive

      t.timestamps null: false
    end
    add_foreign_key :question_votes, :questions
    add_foreign_key :question_votes, :users

    add_index :question_votes, [:question_id, :user_id]
  end
end
