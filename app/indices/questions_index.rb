ThinkingSphinx::Index.define :question, :with => :active_record do
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :users, sortable: true
  indexes answers.body, as: :answers
  indexes comments.body, as: :comments

  has user_id, created_at, updated_at
end