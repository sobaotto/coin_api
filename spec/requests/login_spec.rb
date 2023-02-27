# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /login', type: :request do
  describe 'ログイン機能' do
    let(:user) { create(:user) }

    context '入力されたemailに紐づくユーザー情報が存在する場合' do
      it '正しいパラメーターでログインでき、ユーザー情報が返ってくる' do
        login(user: user)
        expect(response).to have_http_status(:success)

        current_user = JSON.parse(response.body, symbolize_names: true)
        expect(current_user[:name]).to eq(user.name)
        expect(current_user[:email]).to eq(user.email)
      end

      it '誤ったパラメーターではログインできず、401が返ってくる' do
        login(user: user, password: 'wrong_password')
        expect(response).to have_http_status(:bad_request)
      end
    end

    context '入力されたemailに紐づくユーザー情報が存在しない場合' do
      it 'ログインできず、404が返ってくる' do
        login(email: 'unknown@example.com')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
