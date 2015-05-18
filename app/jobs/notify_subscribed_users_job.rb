class NotifySubscribedUsersJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.notifications.each do |notification|
      UserMailer.answer_notification(answer, notification.user.email).deliver_later
    end
  end
end
