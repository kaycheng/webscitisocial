FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    list_price { Faker::Number.between(from: 50, to: 100) }
    sell_price { Faker::Number.between(from: 10, to: 50) }
    
    vendor
    category

    trait :with_skus do
      transient do
        amount { 2 }
      end
      skus { build_list :sku, amount }
    end
  end
end