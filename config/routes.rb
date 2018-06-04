Rails.application.routes.draw do
  devise_for :users
  resources :reports, :contracts

  root to: 'user#user_home'
  get '/forgot_password', to: 'user#forgot_password'

  get '/monthly_sales', to: 'dashboard#monthly_sales'
  get '/report_sales', to: 'dashboard#report_sales'
  get '/manager', to: 'dashboard#manager'
  get '/overview', to: 'dashboard#overview'
  get '/logout', to: 'dashboard#logout'
end
