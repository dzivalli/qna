module VotableCntr
  extend ActiveSupport::Concern

  private

  def up_vote(votable)
    if current_user.owns?(votable) || votable.vote_positive?(current_user)
      render json: votable.votes, status: :forbidden
    else
      votable.vote_up!(current_user)
      render json: votable.votes
    end
  end

  def down_vote(votable)
    if current_user.owns?(votable) || votable.vote_negative?(current_user)
      render json: votable.votes, status: :forbidden
    else
      votable.vote_down!(current_user)
      render json: votable.votes
    end
  end
end