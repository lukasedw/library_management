class Book < ApplicationRecord
  acts_as_paranoid

  belongs_to :author, inverse_of: :books
  belongs_to :genre, inverse_of: :books
  has_many :book_transactions, inverse_of: :book

  validates :title, presence: true, uniqueness: true
  validates :isbn, presence: true, uniqueness: {case_sensitive: false}
  validates :author, presence: true
  validates :genre, presence: true
end
