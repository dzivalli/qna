class AnswerPolicy < ApplicationPolicy
  include VotedPolicy

  def choice?
    user && record.question.user == user
  end
end
