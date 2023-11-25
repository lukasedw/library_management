class Genre < ApplicationRecord
  acts_as_paranoid

  has_many :books, inverse_of: :genre

  validates :name, presence: true, uniqueness: true
end
