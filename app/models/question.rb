class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :answer

  validates :title, presence: true
  validates :body, presence: true

  def change_best(current_answer)
    update(answer: nil) if current_answer == answer
  end
end
