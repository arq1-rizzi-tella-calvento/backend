FactoryBot.define do
  factory :chair do
    quota 35
    subject_in_quarter
    time 'Lunes y Miercoles de 18:00 - 22:00 hs'

    trait :with_over_demand do
      quota 1

      after(:build) do |chair|
        2.times { chair.answers << build(:answer) }
      end
    end
  end
end
