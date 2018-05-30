class UserController < ApplicationController
  before_action :verify_user_status
  before_action :generate_token, only: [:json_maker]
  layout 'main'
  before_action :graphic_path

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
    zapper = ZapierRuby::Zapper.new(:example_zap)
    result = if zapper.zap(json_maker)
               'Email enviado com sucesso'
             else
               'Falha ao enviar email'
             end
    redirect_to root_path, notice: result
  end

  private

  def generate_token
    @token_gen = SecureRandom.base58(24)
    @user_email = params[:user][:email]
    save_token(fetch_id_by_email(@user_email))
  end

  def json_maker
    {
      email: @user_email,
      link: ENV['link_to_edit'] + edit_password_path,
      token: @token_gen
    }
  end

  def save_token
    TokenPassword.new(token: @token_gen, used: 'no', user_id: @user_email).save
  end

  def verify_user_status
    redirect_to graphic_path if user_signed_in?
    @user = User.new
  end

  def graphic_path
    @report = fetch_last_report
    @graphic_path = '/graphic/' + @report.month + '/' + @report.year.to_s
  end
end
