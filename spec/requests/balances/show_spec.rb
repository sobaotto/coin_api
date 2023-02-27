# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /users/:id/balance', type: :request do
  describe '残高確認機能' do
    let(:user_a) { create(:user, name: 'user_a') }
    let(:user_b) { create(:user, name: 'user_b') }

    context 'ログインしている場合' do
      before :each do
        login(user: user_a)
        expect(response).to have_http_status(:success)
      end

      context '自分のuser_idをparamsとして送った場合' do
        it '残高情報が取得できる' do
          get "#{user_path(user_a.id)}/balance"
          expect(response).to have_http_status(:success)

          user_details = JSON.parse(response.body, symbolize_names: true)

          expect(user_details[:id]).to eq(user_a.id)
          expect(user_details[:balance]).to eq(user_a.balance)
        end
      end

      context '他人のuser_idをparamsとして送った場合' do
        it '残高情報は取得できず、403が返される' do
          get "#{user_path(user_b.id)}/balance"
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ログインしていない場合' do
      it '残高情報は取得できず、401が返される' do
        get "#{user_path(user_a.id)}/balance"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
