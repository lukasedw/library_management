FactoryBot.define do
  factory :user do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    trait :librarian do
      role { :librarian }
    end

    trait :member do
      role { :member }
    end
  end
end
