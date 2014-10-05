Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users

  namespace :api do
    get 'candidate_transactions' => 'candidate_transactions#index'
    get 'candidate_transactions/:id' => 'candidate_transactions#show'

    namespace :analytics do
      get 'candidate_transactions/amounts_by_state' => 'candidate_transactions#amounts_by_state'
      get 'candidate_transactions/amounts_by_filer' => 'candidate_transactions#amounts_by_filer'
      get 'candidate_transactions/amounts_by_filer_contributor_payee' => 'candidate_transactions#amounts_by_filer_contributor_payee'
    end
  end
end
