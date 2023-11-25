FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    isbn { Faker::Number.number(digits: 13).to_s }
    total_copies { Faker::Number.between(from: 1, to: 100) }
    author
    genre
  end
end
