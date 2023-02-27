# frozen_string_literal: true

module Balances
  class UpdateOperation
    class << self
      def execute(params:)
        new(params: params).execute
      end
    end

    def initialize(params:)
      @user = User.find_by!(id: params[:id])
      @type = params[:type].to_i
      @amount = params[:amount].to_i
    end

    def execute
      # 残高の更新と取引記録は両方確実に残す必要があるので、
      # どこかで処理が失敗したときはロールバックするようにした
      ActiveRecord::Base.transaction do
        case @type
        when Transaction.types[:withdraw]
          @user.withdraw(amount: @amount)
        when Transaction.types[:deposit]
          @user.deposit(amount: @amount)
        end
      end
    end
  end
end
