class RegistrationsController < Devise::RegistrationsController
  def edit_password
    build_resource(sign_up_params)
    user = fetch_user_by_email(sign_up_params[:email])

    user.encrypted_password = resource.encrypted_password
    user.save
    disable_user_tokens(user.id)

    redirect_to root_path, notice: 'Password changed with success'
  end
end
