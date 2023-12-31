# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

FactoryBot.create(:user, :librarian, first_name: "Librarian", email: "librarian@test.com")
FactoryBot.create(:user, :member, last_name: "Member", email: "member@test.com")

books = FactoryBot.create_list(:book, 5)

users = FactoryBot.create_list(:user, 5, :member)

users.each do |user|
  books.each do |book|
    FactoryBot.create(:book_transaction, user: user, book: book)
  end
end
