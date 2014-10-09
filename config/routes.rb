Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'candidates#index'
  devise_for :users
  resources :users

  get '/candidates/autocomplete_candidate_ballot_name'
  get '/candidates' => 'candidates#index'
  get '/candidates/:id' => 'candidates#show', as: 'candidate'

  namespace :api do
    get 'campaign_finance_transactions' => 'campaign_finance_transactions#index'
    get 'campaign_finance_transactions/:id' => 'campaign_finance_transactions#show'

    namespace :analytics do
      get 'campaign_finance_transactions/amounts_by_state' => 'campaign_finance_transactions#amounts_by_state'
      get 'campaign_finance_transactions/amounts_by_filer' => 'campaign_finance_transactions#amounts_by_filer'
      get 'campaign_finance_transactions/amounts_by_filer_contributor_payee' => 'campaign_finance_transactions#amounts_by_filer_contributor_payee'
    end
  end
end
