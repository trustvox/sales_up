Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/404', to: 'errors#error_404'
  get '/500', to: 'errors#error_500'

  root to: 'user#user_home'
  get '/forgot_password', to: 'user#forgot_password', as: 'forgot_password'

  get '/graphic', to: 'home#graphic'
  get '/spreadsheet', to: 'home#spreadsheet'
  get '/search', to: 'home#search'
  get '/logout', to: 'home#logout'

  get '/manager', to: 'management#manager'
  post '/view', to: 'management#view'
  post '/add_spreadsheet', to: 'management#add_spreadsheet'
  post '/alter_spreadsheet', to: 'management#alter_spreadsheet'

  post '/add_contract', to: 'management#add_contract'
  post '/alter_contract', to: 'management#alter_contract'

  post '/search_spreedsheet', to: 'management#search_spreadsheet'
  post '/search_contract', to: 'management#search_contract'

  post '/delete_spreadsheet', to: 'management#delete_spreadsheet'
  post '/delete_contract', to: 'management#delete_contract'
end
