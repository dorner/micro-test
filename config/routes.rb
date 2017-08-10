Rails.application.routes.draw do

  root :to => 'test#home'

  get 'ping',      to: "ping#index"
  match '/login',  to: 'sessions#login',  via: [:get, :post]
  match '/logout', to: 'sessions#logout', via: [:get, :post]

  get 'home', to: 'test#home'

  resources :stored_jobs, only: [:index] do
    post :queue_test_job, on: :collection
  end

end
