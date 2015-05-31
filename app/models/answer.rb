class Answer < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  include Reputable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, presence: true

  scope :best_first, -> { order(best: :desc) }

  after_create :notification_to_question_owner
  after_create :notification_to_described_users

  def best!
    question.answers.update_all best: false
    update best: true
  end

  private

  def notification_to_question_owner
    UserMailer.answer_notification(self, question.user.email).deliver_later
  end

  def notification_to_described_users
    NotifySubscribedUsersJob.perform_later(self)
  end
end
