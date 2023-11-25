class Author < ApplicationRecord
  acts_as_paranoid

  has_many :books, inverse_of: :author
end
