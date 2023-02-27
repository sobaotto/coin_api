# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    user
    type { Transaction.types[:deposit] }
    amount { ::Test::Constant::DEFAULT_AMOUNT }
  end
end
