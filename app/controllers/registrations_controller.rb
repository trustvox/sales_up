class RegistrationsController < Devise::RegistrationsController
  def create
    redirect_to root_path if sign_up_params[:full_name].blank?
    sign_up_params[:full_name] != 'edit' ? add_new_user : edit_password
  end

  private

  def edit_password
    build_resource(sign_up_params)
    user = fetch_user_by_email(sign_up_params[:email])

    user.encrypted_password = resource.encrypted_password
    user.save

    disable_user_tokens(user.id)
    redirect_to root_path, notice: 'Password changed with success'
  end

  def add_new_user
    build_resource(sign_up_params)
    resource.priority = -1
    resource.save
    yield resource if block_given?

    resource.persisted? ? sign_up_success : sign_up_failure(resource)
  end

  def sign_up_success
    zapper = ZapierRuby::Zapper.new(:email_zap)
    fetch_user_by_priority(2).each do |manager|
      zapper.zap(json_maker(manager.email, 'New user registration',
                            'A new user has just sign up: ' +
                            ENV['link_to_root']))
    end

    redirect_to root_path,
                notice: 'Registration complete. Wait until further permission'
  end

  def sign_up_failure(answer)
    clean_up_passwords answer
    set_minimum_password_length
    redirect_to sign_up_path,
                alert: answer.errors.full_messages.each { |msg| msg }
  end
end
