module Reputated
  extend ActiveSupport::Concern

  included do
    before_action :save_controller_data, only: [:up, :down, :choice]
  end

  private

  def save_controller_data
    reputable = instance_variable_get "@#{controller_name.singularize}"
    reputable.controller_data = [controller_name, action_name]
  end
end