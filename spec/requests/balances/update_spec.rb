# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /users/:id/balance', type: :request do
  describe '残高更新機能' do
    let(:user_a) { create(:user, name: 'user_a', balance: ::Test::Constant::DEFAULT_BALANCE) }
    let(:user_b) { create(:user, name: 'user_b') }

    context 'ログインしている場合' do
      before :each do
        login(user: user_a)
        expect(response).to have_http_status(:success)
      end

      context '自分のuser_idをparamsとして送った場合' do
        context '入金に関する場合' do
          let(:deposit_amount) { 100 }
          let!(:expected_balance) { user_a.balance + deposit_amount }
          let(:params) { { type: "deposit", amount: deposit_amount } }

          it '残高が加算され、200が返る' do
            put "#{user_path(user_a.id)}/balance", params: params
            expect(response).to have_http_status(:success)

            user_details = JSON.parse(response.body, symbolize_names: true)

            expect(user_details[:id]).to eq(user_a.id)
            expect(user_details[:balance]).to eq(expected_balance)
          end
        end

        context '出金に関する場合' do
          context '残高が足りる場合' do
            let(:withdraw_amount) { 100 }
            let!(:expected_balance) { user_a.balance - withdraw_amount }
            let(:params) { { type: "withdraw", amount: withdraw_amount } }

            it '残高が減算され、200が返る' do
              put "#{user_path(user_a.id)}/balance", params: params
              expect(response).to have_http_status(:success)

              user_details = JSON.parse(response.body, symbolize_names: true)

              expect(user_details[:id]).to eq(user_a.id)
              expect(user_details[:balance]).to eq(expected_balance)
            end
          end

          context '残高不足の場合' do
            let(:withdraw_amount) { 1000 }
            let(:params) { { type: "withdraw", amount: withdraw_amount } }

            it '残高は更新できず、400が返される' do
              put "#{user_path(user_a.id)}/balance", params: params
              expect(response).to have_http_status(:bad_request)
            end
          end
        end
      end

      context '他人のuser_idをparamsとして送った場合' do
        let(:deposit_amount) { 100 }
        let(:params) { { type: Transaction.types[:deposit], amount: deposit_amount } }

        it '残高は更新できず、403が返される' do
          put "#{user_path(user_b.id)}/balance", params: params
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ログインしていない場合' do
      let(:deposit_amount) { 100 }
      let(:params) { { type: Transaction.types[:deposit], amount: deposit_amount } }

      it '残高は更新できず、401が返される' do
        put "#{user_path(user_a.id)}/balance", params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
