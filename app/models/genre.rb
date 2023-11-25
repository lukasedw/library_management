class Genre < ApplicationRecord
  acts_as_paranoid

  has_many :books, inverse_of: :genre
end
