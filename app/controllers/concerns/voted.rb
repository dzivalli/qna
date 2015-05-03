module Voted
  extend ActiveSupport::Concern

  included do
    before_action :vote, only: [:up, :down]
  end

  def up
  end

  def down
  end

  private

  def vote
    votable = instance_variable_get "@#{controller_name.singularize}"
    if current_user.owns?(votable) || votable.check_vote?(current_user, action_name)
      render json: votable.votes, status: :forbidden
    else
      votable.vote! current_user, action_name
      render json: votable.votes
    end
  end
end