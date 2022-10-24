# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    user_name { Faker::Lorem.words }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
