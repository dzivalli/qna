class AnswerPolicy < ApplicationPolicy
  def up?
    user && record.user != user
  end

  def down?
    user && record.user != user
  end

  def choice?
    user && record.question.user == user
  end
end
