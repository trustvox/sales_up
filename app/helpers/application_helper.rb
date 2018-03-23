# frozen_string_literal: true

# ApplicationHelper is responsible to create some path options for the user by
#   utilising the devise gem paths.
module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
