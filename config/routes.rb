Rails.application.routes.draw do
  defaults format: :json do
    get '/me', to: 'sessions#show'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    resources :users, only: %i[show create] do
      member do
        resource :balance, only: %i[show update]
        post :transfer, to: 'balances#transfer'
        get :history, to: 'balances#history'
      end
    end
  end
end
