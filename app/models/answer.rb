class Answer < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  include Reputable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_first, -> { order(best: :desc) }

  after_create :send_notification

  def best!
    question.answers.update_all best: false
    update best: true
  end

  private

  def send_notification
    UserMailer.answer_notification(self).deliver_later
  end
end
