class UserMailer < ApplicationMailer

  def digest(user)
    @questions = Question.for_last_day
    mail(to: user.email, subject: 'Daily digest')
  end

  def answer_notification(answer, email)
    @answer = answer
    mail(to: email, subject: 'New answer')
  end
end
