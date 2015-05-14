module Reputable
  extend ActiveSupport::Concern

  included do
    attr_accessor :controller_data
    after_save :update_reputation
  end

  private

  def update_reputation
    Reputation.calculate(user, controller_data) if controller_data
  end
end