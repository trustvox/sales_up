class UserController < ApplicationController
  before_action :verify_user_status
  before_action :generate_token, only: [:after_forgot_password]
  layout 'main'

  def user_home; end

  def forgot_password; end

  def edit_password
    redirect_to root_path unless fetch_token_usage(params[:token])
  end

  def root_without_locale
    redirect_to root_path(locale: :pt)
  end

  def after_forgot_password
    zapper = ZapierRuby::Zapper.new(:email_zap)
    result = if zapper.zap(
      json_maker(@user_email, t('home.zapier-content'), @link)
    )
               t('home.zapier-success')
             else
               t('home.zapier-invalid')
             end

    redirect_to root_path, notice: result
  end

  private

  def generate_token
    @token = SecureRandom.base58(24)
    @user_email = params[:user][:email]

    save_token(fetch_user_by_email(@user_email).id)
    @link = ENV['link_to_root'] + edit_password_path +
            '?token=' + @token + '&email=' + @user_email
  end

  def save_token(id)
    TokenPassword.new(token: @token, used: 'no', user_id: id).save
  end

  def verify_user_status
    redirect_to overview_months_am_path(locale: :pt) if user_signed_in?
    
    @user = User.new
  end
end
