Rails.application.routes.draw do
  devise_for :users
  resources :reports, :contracts

  root to: 'user#user_home'
  get '/forgot_password', to: 'user#forgot_password'

  get '/graphic', to: 'page#graphic'
  get '/spreadsheet', to: 'page#spreadsheet'
  get '/manager', to: 'page#manager'
  get '/overview', to: 'page#overview'
  get '/logout', to: 'page#logout'

  get '/search', to: 'dashboard#search'
end
