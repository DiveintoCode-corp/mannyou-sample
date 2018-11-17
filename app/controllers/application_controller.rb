class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == "production"

  include SessionsHelper
  def require_logged_in
    redirect_to new_session_path, notice: t("layout.session.require_login") unless logged_in?
  end
end
