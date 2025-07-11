# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.delete_all

User.create(email_address: "jay@hey.com", password: "pwn")

Product.delete_all

Product.create!(
  title: "Alaska scenery painting",
  description: "This was painted by yours truly. I know, I was quite surprised myself. 🎨😉🖌️",
  price: 13.37,
).image.attach(
  io: File.open(Rails.root.join("db", "images", "alaska.jpg")),
  filename: "Alaska scenery painting.jpg",
)

Product.create!(
  title: "Child's Play",
  description: "Like, literally...",
  price: 12.34,
).image.attach(
  io: File.open(Rails.root.join("db", "images", "childs_play.jpg")),
  filename: "Childs Play.jpg",
)

Product.create!(
  title: "Mosaic coasters",
  description: "Glass tiles to keep your table safe from glass.",
  price: 9.99,
).image.attach(
  io: File.open(Rails.root.join("db", "images", "mosaic_coasters.jpg")),
  filename: "Mosaic coasters.jpg",
)

Product.all.each do |product|
  product.image.variant(:thumb).processed
end
