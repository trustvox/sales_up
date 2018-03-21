# frozen_string_literal: true

# Custom Failure is responsible to redirect the user to a different path
#   if the user tries to enter a web page without being logged in
class CustomFailure < Devise::FailureApp
  def redirect_url
    root_path
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
