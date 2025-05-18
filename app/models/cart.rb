class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def empty?
    line_items.empty?
  end

  def total_price
    line_items.map { _1.total_price }.reduce(&:+)
  end
end
