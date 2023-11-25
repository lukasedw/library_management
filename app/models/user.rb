class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist

  devise :database_authenticatable, :registerable,
    :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :book_transactions, inverse_of: :user
end
