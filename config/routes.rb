Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :reports, :contracts

  root to: 'user#user_home'
  get '/forgot_password', to: 'user#forgot_password'
  get '/edit_password', to: 'user#edit_password'
  get '/sign_up', to: 'user#register'
  get '/users/:email(.:format)', to: 'user#after_forgot_password'

  get '/graphic', to: 'page#graphic'
  get '/spreadsheet', to: 'page#spreadsheet'
  get '/manager', to: 'page#manager'
  get '/overview', to: 'page#overview'
  get '/logout', to: 'page#logout'
  post '/manage_new_user', to: 'page#manage_new_user'

  get '/search', to: 'dashboard#search'
end
