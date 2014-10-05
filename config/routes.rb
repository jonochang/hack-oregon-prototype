Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users

  namespace :api do
    get 'candidate_transactions' => 'candidate_transactions#index'
    get 'candidate_transactions/:id' => 'candidate_transactions#show'
  end
end
