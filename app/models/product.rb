class Product < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb,   resize_to_limit: [ 150, 100 ], preprocessed: true
    attachable.variant :preview, resize_to_limit: [ 640, 480 ], preprocessed: true
  end

  has_many :line_items

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0.00 }

  validate :acceptable_image_type

  after_commit do
    broadcast_refresh_later_to "products"
    broadcast_replace_later_to "store/products", partial: "store/product"
  end
  before_destroy :ensure_not_referenced_by_any_line_item

  private

  def acceptable_image_type
    return unless image.attached?

    acceptable_types = %w[image/gif image/jpeg image/png]
    unless acceptable_types.include? image.content_type
      errors.add(:image, "must be a GIF, JPEG or PNG image")
    end
  end

  def ensure_not_referenced_by_any_line_item
    if line_items.any?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end
end
