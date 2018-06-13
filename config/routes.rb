Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :reports, :contracts

  root to: 'user#user_home'
  get '/forgot_password', to: 'user#forgot_password'
  get '/edit_password', to: 'user#edit_password'
  get '/sign_up', to: 'user#register'
  get '/users/:email(.:format)', to: 'user#after_forgot_password'

  get '/monthly_sales', to: 'dashboard#monthly_sales'
  get '/report_sales', to: 'dashboard#report_sales'
  get '/manager', to: 'dashboard#manager'
  get '/overview_months', to: 'dashboard#overview_months'
  get '/overview_reports', to: 'dashboard#overview_reports'
  get '/logout', to: 'dashboard#logout'
end
