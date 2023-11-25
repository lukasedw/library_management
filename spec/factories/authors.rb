FactoryBot.define do
  factory :author do
    name { Faker::Book.author }
    description { Faker::Lorem.paragraph }
  end
end
