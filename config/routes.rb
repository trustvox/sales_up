Rails.application.routes.draw do
  get '/', to: 'user#root_without_locale'

  scope ':locale' do
    devise_for :users, controllers: { registrations: 'registrations' }

    root to: 'user#user_home'
    get '/forgot_password', to: 'user#forgot_password'
    get '/edit_password', to: 'user#edit_password'
    get '/users/:email(.:format)', to: 'user#after_forgot_password'

    scope :admin, module: 'admin' do
      resources :reports

      get '/manager', to: 'manager#manager_settings'
      post '/manage_new_user', to: 'manager#manage_new_user'
    end
  end
end

Rails.application.routes.draw do
  scope ':locale' do
    scope :account_manager, module: 'account_manager' do
      resources :contracts, :report_observations

      get '/monthly_sales', to: 'dashboard#monthly_sales'
      get '/report_AM', to: 'dashboard#report_AM'
      get '/overview_months_AM', to: 'dashboard#overview_months_AM',
                              as: :overview_months_AM
      get '/overview_reports_AM', to: 'dashboard#overview_reports_AM',
                                as: :overview_reports_AM
      get '/logout', to: 'dashboard#logout'
    end

    scope :sales_representative, module: 'sales_representative' do
      resources :meetings

      get '/monthly_schedules', to: 'dashboard#monthly_schedules'
      get '/overview_months_SDR',   to: 'dashboard#overview_months_SDR',
                                as: :overview_months_SDR
      get '/overview_reports_SDR',  to: 'dashboard#overview_reports_SDR',
                                as: :overview_reports_SDR
      get '/report_SDR',     to: 'dashboard#report_SDR'
    end
  end
end
