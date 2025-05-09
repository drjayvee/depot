class Product < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 100], preprocessed: true
    attachable.variant :preview, resize_to_limit: [640, 480], preprocessed: true
  end

  after_commit { broadcast_refresh_later_to "products" }

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0.00 }
end
