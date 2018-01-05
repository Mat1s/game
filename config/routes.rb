Rails.application.routes.draw do
	require 'sidekiq/web'
	mount Sidekiq::Web => "/sidekiq"
  get 'worker', to: 'games#worker'
  get 'sheduler', to: 'games#sheduler'


  root 'games#index'

  resources :games, only: [:index, :show, :create, :new]
  resources :cash_accounts

  devise_for :users
end
