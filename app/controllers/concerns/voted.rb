module Voted
  extend ActiveSupport::Concern

  included do
    before_action :action_list, only: [:up, :down]
  end

  def up
  end

  def down
  end

  private

  # couldn't find another way
  def action_list
    authenticate_user!
    find_votable
    vote
  end

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