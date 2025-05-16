class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def empty?
    line_items.empty?
  end
end
