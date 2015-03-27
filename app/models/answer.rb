class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_first, -> { order(best: :desc) }

  def belongs_to?(current_user)
    current_user && user_id == current_user.id
  end

  def best!
    question.answers.update_all best: false
    update best: true
  end
end
