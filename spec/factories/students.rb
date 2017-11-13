FactoryBot.define do
  factory :student do
    sequence(:name) { |n| "Estudiante #{n}" }
    sequence(:email) { |n| "mail#{n}@test.com" }
    sequence(:identity_document) { |n| 42_054_540 + n }
  end
end
