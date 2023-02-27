# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_login, except: :create

  def show
    current_user
  end

  # ビジネスロジックをコントローラーから切り出すために、
  # DBの状態を変更する処理に関しては、Operationクラスを用いてます。
  def create
    user = Users::CreateOperation.execute(params: create_params)
    session[:user_id] = user.id
  rescue ActiveRecord::RecordInvalid => e
    render_bad_request
  # 予期せぬ例外はここでキャッチする
  rescue StandardError => e
    render_bad_request_with_message(message: e.message)
  end

  private

  def create_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
