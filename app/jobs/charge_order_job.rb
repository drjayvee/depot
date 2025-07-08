# frozen_string_literal: true

class ChargeOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    order.charge!
  end
end
