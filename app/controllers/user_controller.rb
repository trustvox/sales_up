class UserController < ApplicationController
  layout 'main'

  def user_home
    redirect_to graphic_path if user_signed_in?
  end

  def forgot_password; end
end
