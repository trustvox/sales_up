Rails.application.routes.draw do
  resources :user 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "user#index"
  get "/forgot_password" => "user#forgot_password"
  get "/spreadsheet" => "logged#spreadsheet"
  get "/graphic" => "logged#graphic"
 
end
