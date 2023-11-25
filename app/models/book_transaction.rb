class BookTransaction < ApplicationRecord
  belongs_to :book, inverse_of: :book_transactions
  belongs_to :user, inverse_of: :book_transactions
end
