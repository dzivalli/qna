module Reputated
  extend ActiveSupport::Concern

  included do
    before_action :save_temp_data, only: [:up, :down, :choice]
  end

  private

  def save_temp_data
    reputable = instance_variable_get "@#{controller_name.singularize}"
    reputable.temp_data = [current_user, controller_name, action_name]
  end
end