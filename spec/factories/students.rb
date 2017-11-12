FactoryBot.define do
  factory :student do
    email "student#{Random.rand(100)}@mail.com"
    name 'Johnny Bravo'
    identity_document Random.rand(99_999)
  end
end
