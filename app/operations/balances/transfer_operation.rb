# frozen_string_literal: true

module Balances
  class TransferOperation
    class << self
      def execute(params:)
        new(params: params).execute
      end
    end

    def initialize(params:)
      @sender_user = User.find_by!(id: params[:id])
      @recipient_user = User.find_by!(id: params[:recipient_id])
      @amount = params[:amount].to_i
    end

    def execute
      # 送金元口座の減算と受取元口座の加算の整合性を保つために、
      # どこかで処理が失敗したときはロールバックするようにした
      ActiveRecord::Base.transaction do
        @sender_user.withdraw(amount: @amount)
        @recipient_user.deposit(amount: @amount)
      end
    end
  end
end
