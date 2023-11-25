class Book < ApplicationRecord
  acts_as_paranoid

  belongs_to :author, inverse_of: :books
  belongs_to :genre, inverse_of: :books
end
