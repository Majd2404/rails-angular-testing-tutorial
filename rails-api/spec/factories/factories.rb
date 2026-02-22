# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name  { Faker::Name.full_name }
    email { Faker::Internet.unique.email }
    age   { rand(18..65) }

    # Trait for an admin user
    trait :admin do
      name { "Admin User" }
      email { "admin@example.com" }
    end

    # Trait for invalid user (for negative tests)
    trait :invalid do
      name  { "" }
      email { "not-an-email" }
    end
  end
end

# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title   { Faker::Lorem.sentence(word_count: 4) }
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    status  { "draft" }
    association :user

    trait :published do
      status       { "published" }
      published_at { Time.current }
    end

    trait :archived do
      status { "archived" }
    end
  end
end
