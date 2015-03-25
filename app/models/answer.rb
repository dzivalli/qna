class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :best, foreign_key: :answer_id, class_name: Question

  validates :body, presence: true

  scope :best_first, -> { includes(:best).order('questions.answer_id') }

  def belongs_to?(current_user)
    user == current_user
  end
end
