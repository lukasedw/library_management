FactoryBot.define do
  factory :author do
    name { Faker::Book.unique.author }
    description { Faker::Lorem.paragraph }
  end
end
