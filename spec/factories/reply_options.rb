FactoryBot.define do
  factory :reply_option do
    value ReplyOption::REPLY_OPTIONS.first
    association :subject, factory: :subject, strategy: :build
  end
end
