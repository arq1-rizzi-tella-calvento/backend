FactoryBot.define do
  factory :survey do
    start_date Date.new(2017, 3, 1)
    end_date Date.new(2017, 3, 10)
    quarter 1

    trait :for_second_quarter do
      start_date Date.new(2017, 8, 1)
      end_date Date.new(2017, 8, 10)
      quarter 2
    end
  end
end
