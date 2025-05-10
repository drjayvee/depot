class Product < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 100], preprocessed: true
    attachable.variant :preview, resize_to_limit: [640, 480], preprocessed: true
  end

  after_commit { broadcast_refresh_later_to "products" }

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0.00 }

  validate :acceptable_image_type

  def acceptable_image_type
    return unless image.attached?

    acceptable_types = %w[image/gif image/jpeg image/png]
    unless acceptable_types.include? image.content_type
      errors.add(:image, "must be a GIF, JPEG or PNG image")
    end
  end
end
