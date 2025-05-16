class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  validate :prevent_duplicate_line_items

  def empty?
    line_items.empty?
  end

  private

  def prevent_duplicate_line_items
    stored_product_ids = line_items.pluck(:product_id).uniq

    line_items.select(&:new_record?).each do |item|
      if stored_product_ids.include? item.product_id
        errors.add(:line_items, "Cart already contains line item for product #{item.product_id}")
      end
    end
  end
end
