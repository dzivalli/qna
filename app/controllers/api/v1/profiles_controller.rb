class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    respond_with @owner
  end

  def index
    respond_with User.except_of(@owner)
  end
end