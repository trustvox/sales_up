class UserController < ApplicationController
  before_action :verify_user_status
  before_action :generate_token, only: [:after_forgot_password]
  layout 'main'

  def user_home; end

  def forgot_password; end

  def create_schedule
    meet = Meeting.new
      
    meet.client_name = verify_client_name
    meet.day = Time.current.day
    user = fetch_user_by_email(params[:sdr_name])

    meet.scheduled_for = params[:schedule_date].tr(',', '')
    meet.meeting_for = verify_meeting_for(user)

    meet.user_id = user.id
    meet.report_id = fetch_last_report('sdr').id
    meet.save
    
    redirect_to root_path
  end
    
  def create_deal
    search_deal = fetch_deal_by_client(params[:client_name])
    
    change_deal(search_deal.nil? ? Deal.new : search_deal)

    redirect_to root_path
  end

  def destroy_deal
    fetch_deal_by_client(params[:client_name]).destroy
    
    redirect_to root_path
  end

  def edit_password
    redirect_to root_path unless fetch_token_usage(params[:token])
  end

  def root_without_locale
    redirect_to root_path(locale: :pt)
  end

  def after_forgot_password
    zapper = ZapierRuby::Zapper.new(:email_zap)
    result = if zapper.zap(
      json_maker(params[:user][:email], t('home.zapier-content'), @link)
    )
               t('home.zapier-success')
             else
               t('home.zapier-invalid')
             end

    redirect_to root_path, notice: result
  end

  private

  def generate_token
    token = SecureRandom.base58(24)
    user_email = params[:user][:email]

    save_token(fetch_user_by_email(user_email).id, token)
    @link = ENV['link_to_root'] + edit_password_path +
            '?token=' + token + '&email=' + @user_email
  end

  def save_token(id, token)
    TokenPassword.new(token: token, used: 'no', user_id: id).save
  end

  def verify_user_status
    redirect_to overview_months_am_path(locale: :pt) if user_signed_in?
  end

  def verify_client_name
    client = params[:client_name].split('>')[-1]
    
    redirect_to root_path unless fetch_meeting_by_client_name(client).nil?

    client
  end

  def verify_meeting_for(user)
    return user.full_name if user.am?
      
    fetch_user_by_email(params[:am_name].split(',')[0]).full_name
  end

  def change_deal(deal)
    deal.user_id = fetch_user_by_email(params[:am_email]).id

    date = params[:date].split('/')
    deal.day = date[0]
    deal.report_id = 
      fetch_report_with_month_number(date[1][-1], date[2], SIDES[0]).id

    deal.value = params[:value][0..-4].gsub('.', '')
    deal.client_name = params[:client_name]

    deal.save
  end
end
