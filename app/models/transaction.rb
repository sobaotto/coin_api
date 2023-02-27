# frozen_string_literal: true

class Transaction < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum type: { deposit: 0, withdraw: 1 }

  belongs_to :user

  validates :user_id, presence: true
  validates :type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
