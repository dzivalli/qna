class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :question_as_best, foreign_key: :answer_id, class_name: Question

  validates :body, presence: true

  scope :best_first, -> { includes(:question_as_best).order('questions.answer_id') }

  def belongs_to?(current_user)
    current_user && user_id == current_user.id
  end
end
