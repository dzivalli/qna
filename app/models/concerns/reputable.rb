module Reputable
  extend ActiveSupport::Concern

  included do
    attr_accessor :temp_data
    after_save :update_reputation
  end

  private

  def update_reputation
    Reputation.calculate(temp_data) if temp_data
  end
end