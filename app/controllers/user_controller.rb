class UserController < ApplicationController

	def home
		if user_signed_in?
      redirect_to graphic_path
    end
	end

	def forgot_password
		
	end

end