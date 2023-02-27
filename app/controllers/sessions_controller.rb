# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_login, except: :create

  def show
    current_user
  end

  # ビジネスロジックをコントローラーから切り出すために、
  # DBの状態を変更する処理に関しては、Operationクラスを用いてます。
  def create
    user = Sessions::CreateOperation.execute(params: create_params)
    session[:user_id] = user.id
  rescue ActiveRecord::RecordNotFound => e
    render_not_found
  # 予期せぬ例外はここでキャッチする
  rescue StandardError => e
    render_bad_request_with_message(message: e.message)
  end

  def destroy
    reset_session
  end

  private

  def create_params
    params.permit(:email, :password)
  end
end
