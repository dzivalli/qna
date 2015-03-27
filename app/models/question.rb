class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, foreign_key: :answer_id, class_name: Answer

  validates :title, presence: true
  validates :body, presence: true

  def change_best(current_answer)
    update(best_answer: nil) if current_answer == best_answer
  end
end
