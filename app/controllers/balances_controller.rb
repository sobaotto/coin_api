# frozen_string_literal: true

class BalancesController < ApplicationController
  before_action :require_login
  before_action lambda {
    validate_user_id(id: params[:id].to_i)
  }

  def show
    current_user
  end

  # ビジネスロジックをコントローラーから切り出すために、
  # DBの状態を変更する処理に関しては、Operationクラスを用いてます。
  def update
    Balances::UpdateOperation.execute(params: update_params)
  rescue ActiveRecord::RecordNotFound => e
    render_not_found
  rescue ActiveRecord::RecordInvalid => e
    render_bad_request
  # 予期せぬ例外はここでキャッチする
  rescue StandardError => e
    render_bad_request_with_message(message: e.message)
  end

  def transfer
    Balances::TransferOperation.execute(params: transfer_params)
  rescue ActiveRecord::RecordNotFound => e
    render_not_found
  rescue ActiveRecord::RecordInvalid => e
    render_bad_request
  # 予期せぬ例外はここでキャッチする
  rescue StandardError => e
    render_bad_request_with_message(message: e.message)
  end

  # ビジネスロジックをコントローラーから切り出すために、
  # DBの状態を変更しない処理に関しては、Queryクラスを用いてます。
  def history
    @histories = Balances::HistoryQuery.new(user: current_user).data
    @total_count = @histories.size
  end

  private

  def update_params
    params.permit(:id, :type, :amount)
  end

  def transfer_params
    params.permit(:id, :amount, :recipient_id)
  end

  def validate_user_id(id:)
    render_forbidden if id != current_user.id
  end
end
