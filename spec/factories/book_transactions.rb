FactoryBot.define do
  factory :book_transaction do
    book
    user
    checkout_at { Time.zone.now }
    return_at { Time.zone.now + 2.weeks }
    state { :borrowed }

    trait :returned do
      state { :returned }
      returned_at { Time.zone.now }
    end

    trait :overdue do
      state { :overdue }
      return_at { Time.zone.now - 2.weeks }
    end
  end
end
