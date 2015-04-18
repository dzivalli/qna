class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :answer_votes, dependent: :destroy

  validates :body, presence: true

  scope :best_first, -> { includes(:attachments).order(best: :desc) }

  accepts_nested_attributes_for :attachments, allow_destroy: true

  def best!
    question.answers.update_all best: false
    update best: true
  end

  def vote_up!(user)
    if vote_of(user) == -1
      answer_votes.find_by(user: user).delete
    else
      answer_votes.create user: user, positive: true
    end
    update votes: votes + 1
  end

  def vote_down!(user)
    if vote_of(user) == 1
      answer_votes.find_by(user: user).delete
    else
      answer_votes.create user: user, positive: false
    end
    update votes: votes - 1
  end

  def vote_of(user)
    return false unless answer_votes.find_by(user: user)
    answer_votes.find_by(user: user).positive ? 1 : -1
  end
end
