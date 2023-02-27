# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :email }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def deposit(amount:)
    self.balance += amount

    Transaction.create!({ user_id: id, type: Transaction.types[:deposit], amount: amount })

    save!
  end

  def withdraw(amount:)
    self.balance -= amount

    Transaction.create!({ user_id: id, type: Transaction.types[:withdraw], amount: amount })

    save!
  end
end
