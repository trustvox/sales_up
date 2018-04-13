class UserController < ApplicationController
  def user_home
    redirect_to graphic_path if user_signed_in?
    render :layout => true
  end

  def forgot_password
    render :layout => true
  end
end
