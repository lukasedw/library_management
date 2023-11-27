class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist

  devise :database_authenticatable, :registerable,
    :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :book_transactions, inverse_of: :user

  validates :first_name, :last_name, :role, presence: true

  enum role: {librarian: 1, member: 0}
end
