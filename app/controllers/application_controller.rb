class ApplicationController < ActionController::Base
  include DatabaseSearchs

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    if user_signed_in?
      stored_location_for(resource) || search_path
    else
      root_path
    end
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path, alert: 'You must sign in first'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'),
      ## :formats => [:html], :status => 404, :layout => false
    end
  end

  def configure_permitted_parameters
    attrs_create = %i[full_name email password password_confirmation]
    attrs_login = %i[email password]

    devise_parameter_sanitizer.permit :sign_in, keys: attrs_login
    devise_parameter_sanitizer.permit :sign_up, keys: attrs_create
    devise_parameter_sanitizer.permit :account_update, keys: attrs_create
  end
end
