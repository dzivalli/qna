class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :question_votes, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :title, presence: true
  validates :body, presence: true

  def vote_up!(user)
    if vote_of(user) == -1
      question_votes.find_by(user: user).delete
    else
      question_votes.create user: user, positive: true
    end
    update votes: votes + 1
  end

  def vote_down!(user)
    if vote_of(user) == 1
      question_votes.find_by(user: user).delete
    else
      question_votes.create user: user, positive: false
    end
    update votes: votes - 1
  end

  def vote_of(user)
    return false unless question_votes.find_by(user: user)
    question_votes.find_by(user: user).positive ? 1 : -1
  end
end
