class Answer < ActiveRecord::Base
  include VotableModel

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :user_votes, as: :votable, dependent: :destroy

  validates :body, presence: true

  scope :best_first, -> { includes(:attachments).order(best: :desc) }

  accepts_nested_attributes_for :attachments, allow_destroy: true

  def best!
    question.answers.update_all best: false
    update best: true
  end
end
