class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_first, -> { order(best: :desc) }

  def best!
    question.answers.update_all best: false
    update best: true
  end
end
