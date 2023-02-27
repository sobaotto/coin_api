# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users/:id/transfer', type: :request do
  describe '送金機能' do
    let!(:user_a) { create(:user, name: 'user_a', balance: ::Test::Constant::DEFAULT_BALANCE) }
    let!(:user_b) { create(:user, name: 'user_b') }

    context 'ログインしている場合' do
      before :each do
        login(user: user_a)
        expect(response).to have_http_status(:success)
      end

      context '自分のuser_idをparamsとして送った場合' do
        context '受取人のuser_idが存在する場合' do
          context '残高が足りる場合' do
            let(:transfer_amount) { 100 }
            let!(:expected_user_a_balance) { user_a.balance - transfer_amount }
            let!(:expected_user_b_balance) { user_b.balance + transfer_amount }
            let(:params) { { amount: transfer_amount, recipient_id: user_b.id } }

            it '自分の残高が減算され、受取人の残高が加算され、200が返る' do
              post "#{user_path(user_a.id)}/transfer", params: params
              expect(response).to have_http_status(:success)

              user_details = JSON.parse(response.body, symbolize_names: true)

              expect(user_details[:id]).to eq(user_a.id)
              expect(user_details[:balance]).to eq(expected_user_a_balance)
              expect(user_b.reload.balance).to eq(expected_user_b_balance)
            end
          end

          context '残高不足の場合' do
            let(:transfer_amount) { 1000 }
            let(:params) { { amount: transfer_amount, recipient_id: user_b.id } }

            it '送金はできず、400が返される' do
              post "#{user_path(user_a.id)}/transfer", params: params
              expect(response).to have_http_status(:bad_request)
            end
          end
        end

        context '受取人のuser_idが存在しない場合' do
          let(:transfer_amount) { 100 }
          let(:unexists_user_id) { user_a.id + 999 }
          let(:params) { { amount: transfer_amount, recipient_id: unexists_user_id } }

          it '送金はできず、404が返される' do
            post "#{user_path(user_a.id)}/transfer", params: params
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context '他人のuser_idをparamsとして送った場合' do
        let(:transfer_amount) { 100 }
        let(:params) { { amount: transfer_amount, recipient_id: user_b.id } }

        it '送金はできず、403が返される' do
          post "#{user_path(user_b.id)}/transfer", params: params
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ログインしていない場合' do
      let(:transfer_amount) { 100 }
      let(:params) { { amount: transfer_amount, recipient_id: user_b.id } }

      it '送金はできず、401が返される' do
        post "#{user_path(user_a.id)}/transfer", params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
