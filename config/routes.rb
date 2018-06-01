Rails.application.routes.draw do
  devise_for :users
  resources :reports, :contracts

  root to: 'user#user_home'
  get '/forgot_password', to: 'user#forgot_password'

  get '/monthly_sales', to: 'page#monthly_sales'
  get '/report_sales', to: 'page#report_sales'
  get '/manager', to: 'page#manager'
  get '/overview', to: 'page#overview'
  get '/logout', to: 'page#logout'

  get '/search', to: 'dashboard#search'
end
