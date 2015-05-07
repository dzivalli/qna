class QuestionPolicy < ApplicationPolicy
  def up?
    user && record.user != user
  end

  def down?
    user && record.user != user
  end
end
