class Author < ApplicationRecord
  acts_as_paranoid

  has_many :books, inverse_of: :author

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
