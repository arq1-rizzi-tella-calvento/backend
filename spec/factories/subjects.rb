FactoryBot.define do
  factory :subject do
    sequence(:name) { |n| "Materia #{n}"}
  end
end