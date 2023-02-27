# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /logout', type: :request do
  describe 'ログイン機能' do
    let(:user) { create(:user) }

    it 'ログアウト状態になり、200が帰ってくる' do
      login(user: user)
      expect(response).to have_http_status(:success)

      delete '/logout'
      expect(response).to have_http_status(:success)
    end
  end
end
