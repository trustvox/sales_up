Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'user#user_home'
  get '/forgot_password', to: 'user#forgot_password'

  get '/graphic', to: 'home#graphic'
  get '/spreadsheet', to: 'home#spreadsheet'
  get '/logout', to: 'home#logout'
  post '/add_contract_data', to: 'home#add_contract_data'
  post '/alter_contract_data', to: 'home#alter_contract_data'
  post '/delete_contract_data', to: 'home#delete_contract_data'

  get '/search', to: 'dashboard#search'
  post '/search_overview_data', to: 'dashboard#search_overview_data'

  get '/manager', to: 'management#manager'
  post '/view', to: 'management#view'
  post '/add_spreadsheet', to: 'management#add_spreadsheet'
  post '/alter_spreadsheet', to: 'management#alter_spreadsheet'
  post '/search_spreedsheet', to: 'management#search_spreadsheet'
  post '/delete_spreadsheet', to: 'management#delete_spreadsheet'

  get '/overview', to: 'management#overview'
end
