FactoryBot.define do
  factory :product do
    title { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Number.decimal(l_digits: 2) }
    vegetarian { Faker::Boolean.boolean }
    category_id { Faker::Number.between(from: 1, to: 4) }
  end
end
