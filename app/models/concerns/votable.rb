module Votable
  extend ActiveSupport::Concern

  def vote_up!
    update votes: votes + 1
  end

  def vote_down!
    update votes: votes - 1
  end
end