class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    resource.persisted? ? send_user_to(resource) : sign_up_failure(resource)
  end

  private

  def send_user_to(answer)
    if answer.active_for_authentication?
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, answer)
      respond_with answer, location: after_sign_up_path_for(answer)
    else
      set_flash_message! :notice,
                         :"signed_up_but_#{answer.inactive_message}"
      expire_data_after_sign_in!
      respond_with answer, location: after_inactive_sign_up_path_for(answer)
    end
  end

  def sign_up_failure(answer)
    clean_up_passwords answer
    set_minimum_password_length
    redirect_to sign_up_path, alert: answer.errors.full_messages.each { |msg| msg }
  end
end
