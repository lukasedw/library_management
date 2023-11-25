FactoryBot.define do
  factory :book_transaction do
    book
    user
    checkout_at { Time.zone.now }
    return_at { Time.zone.now + 2.weeks }
  end
end
