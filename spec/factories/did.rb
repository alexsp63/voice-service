# frozen_string_literal: true

FactoryBot.define do
  factory :did do
    sequence(:number) { |n| "89171358#{n}" }

    association :user
  end
end
