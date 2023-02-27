# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /users/:id/history', type: :request do
  describe '取引履歴確認機能' do
    let(:user_a) { create(:user, name: 'user_a') }
    let(:user_b) { create(:user, name: 'user_b') }
    let!(:transactions) { create_list(:transaction, 2, user_id: user_a.id) }

    context 'ログインしている場合' do
      before :each do
        login(user: user_a)
        expect(response).to have_http_status(:success)
      end

      context '自分のuser_idをparamsとして送った場合' do
        before :each do
          ordered_transactions = transactions.sort { |a, b| b[:created_at] <=> a[:created_at] }
          @expected_histories = ordered_transactions.map do |transaction|
            {
              type: transaction.type,
              amount: transaction.amount,
              created_at: transaction.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
            }
          end
        end

        it '取引履歴が取得できる' do
          get "#{user_path(user_a.id)}/history"
          expect(response).to have_http_status(:success)

          res = JSON.parse(response.body, symbolize_names: true)

          expect(res[:total_count]).to eq(transactions.size)
          expect(res[:id]).to eq(user_a.id)
          expect(res[:balance]).to eq(user_a.balance)
          expect(res[:histories]).to eq(@expected_histories)
        end
      end

      context '他人のuser_idをparamsとして送った場合' do
        it '取引履歴は取得できず、403が返される' do
          get "#{user_path(user_b.id)}/history"
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ログインしていない場合' do
      it '取引履歴は取得できず、401が返される' do
        get "#{user_path(user_a.id)}/history"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
