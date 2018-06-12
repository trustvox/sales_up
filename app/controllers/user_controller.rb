class UserController < ApplicationController
  before_action :verify_user_status
  before_action :generate_token, only: [:after_forgot_password]
  layout 'main'

  def user_home
    report = fetch_last_report
    @current_month = report.month
    @current_year = report.year
  end

  def edit_password
    redirect_to root_path unless verify_token_usage(params[:token])
  end

  def forgot_password; end

  def register; end

  def after_forgot_password
    zapper = ZapierRuby::Zapper.new(:email_zap)
    result = if zapper.zap(json_maker(@user_email,
                                      'Edit password link', @link))
               'Email enviado com sucesso'
             else
               'Falha ao enviar email'
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
    redirect_to monthly_sales_path if user_signed_in?
    @user = User.new
  end
end
