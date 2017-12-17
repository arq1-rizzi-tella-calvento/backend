FactoryBot.define do
  factory :survey do
    start_date 1.week.ago
    end_date 2.weeks.from_now
    quarter 1

    trait :for_second_quarter do
      quarter 2
    end

    trait :ended do
      start_date 2.weeks.ago
      end_date 1.weeks.ago
    end
  end
end
