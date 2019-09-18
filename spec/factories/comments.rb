# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'MyString' }
    post_id { 1 }
    user_id { 1 }
  end
end
