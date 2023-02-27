# frozen_string_literal: true

module Balances
  class HistoryQuery
    def initialize(user:)
      @user = user
    end

    def data
      Transaction.where(user_id: @user.id).order(created_at: :desc)
    end
  end
end
