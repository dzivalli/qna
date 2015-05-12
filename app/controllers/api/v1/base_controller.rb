class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :find_resource_owner
  respond_to :json

  private

  def find_resource_owner
    @owner ||= User.find_by_id(doorkeeper_token.resource_owner_id)
  end
end