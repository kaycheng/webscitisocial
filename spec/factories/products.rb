FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    list_price { Faker::Number.between(from: 50, to: 100) }
    sell_price { Faker::Number.between(from: 10, to: 50) }
    
    vendor
    category
  end
end