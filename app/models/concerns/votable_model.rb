module VotableModel
  extend ActiveSupport::Concern

  def vote_up!(user)
    if vote_negative?(user)
      user_votes.find_by(user: user).delete
    else
      user_votes.create user: user, positive: true
    end
    update votes: votes + 1
  end

  def vote_down!(user)
    if vote_positive?(user)
      user_votes.find_by(user: user).delete
    else
      user_votes.create user: user, positive: false
    end
    update votes: votes - 1
  end

  def vote_positive?(user)
    user_votes.find_by(user: user).positive if user_votes.find_by(user: user)
  end

  def vote_negative?(user)
    !user_votes.find_by(user: user).positive if user_votes.find_by(user: user)
  end
end