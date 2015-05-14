class UserMailer < ApplicationMailer

  def digest(user)
    @questions = Question.for_last_day
    mail(to: user.email, subject: 'Daily digest')
  end
end
