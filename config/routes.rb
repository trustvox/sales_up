Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "user#user_home"
  get "/forgot_password", to: "user#forgot_password", as: "forgot_password"

  get "/login", to: "home#login"
  get "/graphic", to: "home#graphic", as: "graphic"
  get "/spreadsheet", to: "home#spreadsheet", as: "spreadsheet"
  post "/search", to: "home#search"

  get "/manager", to: "management#manager"
  post "/view", to: "management#view"
  post "/search_spreedsheet", to: "management#search_spreadsheet"
  post "/search_contract", to: "management#search_contract"
  post "/delete_spreadsheet", to: "management#delete_spreadsheet"
  post "/delete_contract", to: "management#delete_contract"
 
end
