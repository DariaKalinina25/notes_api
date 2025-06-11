# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    title { "Title" }
    body { "Body" }
    archived { false }
  end
end
