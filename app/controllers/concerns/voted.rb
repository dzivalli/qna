module Voted
  extend ActiveSupport::Concern

  def up
    vote
  end

  def down
    vote
  end

  private

  def vote
    votable = instance_variable_get "@#{controller_name.singularize}"
    if current_user.owns?(votable) || votable.check_vote?(current_user, action_name)
      render json: votable.votes, status: :forbidden
    else
      votable.send :vote!, current_user, action_name
      render json: votable.votes
    end
  end
end