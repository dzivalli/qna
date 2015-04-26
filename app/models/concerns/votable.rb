module Votable
  extend ActiveSupport::Concern

  included do
    has_many :user_votes, as: :votable, dependent: :destroy
  end

  def vote!(user, action)
    if check_vote?(user, 'up') || check_vote?(user, 'down')
      user_votes.find_by(user: user).delete
    else
      user_votes.create user: user, positive: (action == 'up')
    end
    update votes: votes + (action == 'up' ? 1 : -1)
  end

  def check_vote?(user, action = '')
    if user_votes.find_by(user: user)
      if action == 'up'
        user_votes.find_by(user: user).positive
      elsif action == 'down'
        !user_votes.find_by(user: user).positive
      end
    end
  end
end