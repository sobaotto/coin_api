# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users', type: :request do
  let(:params) do
    { 
      name: 'user',
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password' 
    }
  end

  it '新規にユーザー登録ができ、200が返ってくる' do
    post users_path, params: params
    expect(response).to have_http_status(:success)
  end

  it 'paramsが不足して、新規ユーザーの作成に失敗した時は、400を返す' do
    post users_path
    expect(response).to have_http_status(:bad_request)
  end
end
