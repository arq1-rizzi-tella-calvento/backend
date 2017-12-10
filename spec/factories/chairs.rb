FactoryBot.define do
  factory :chair do
    quota 35
    subject_in_quarter
    sequence(:time) { |n| "Lunes y Miercoles de #{n}:00 - #{n + 1}:00 hs" }
    number { subject_in_quarter.chairs.count + 1 }

    trait :with_over_demand do
      quota 1

      after(:build) do |chair|
        2.times { chair.answers << build(:answer) }
      end
    end
  end
end
