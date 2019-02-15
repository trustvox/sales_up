class ApplicationController < ActionController::Base
  include DatabaseSearchs
  include ViewHelper
  
  helper DatabaseSearchs
  helper OverviewHelper
  helper GraphicHelper
  helper ViewHelper

  before_action do
    I18n.locale = params[:locale] || I18n.default_locale
    @notice = params[:notice].nil? ? [[]] : params[:notice]
  end

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def verify_authorization(simbol, class_name)
    authorize! simbol, class_name
  rescue CanCan::AccessDenied
    redirect_to overview_months_AM_path
  end

  def render_menu(type)
    @partial_path = '/partials/menu_' + type
    render layout: 'menu'
  end

  def json_maker(user_email, email_subject, email_content)
    { email: user_email, subject: email_subject, content: email_content }
  end

  def after_sign_in_path_for(resource)
    if user_signed_in?
      stored_location_for(resource) ||
      resource.sdr? ? monthly_schedules_path : monthly_sales_path
    else
      root_path
    end
  end

  def authenticate_user!
    redirect_to root_path, alert: 'You must signin first' unless user_signed_in?
  end

  def configure_permitted_parameters
    attrs_create = %i[full_name email password password_confirmation]
    attrs_login = %i[email password]

    devise_parameter_sanitizer.permit :sign_in, keys: attrs_login
    devise_parameter_sanitizer.permit :sign_up, keys: attrs_create
    devise_parameter_sanitizer.permit :account_update, keys: attrs_create
  end
end
