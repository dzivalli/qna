class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :find_resource_owner
  respond_to :json

  def me
    respond_with @owner
  end

  def index
    respond_with User.except_of(@owner)
  end

  private

  def find_resource_owner
    @owner ||= User.find_by_id(doorkeeper_token.resource_owner_id)
  end
end