class ApplicationController < ActionController::Base
  include SessionsHelper

  def require_logged_in
    redirect_to new_session_path, notice: t("layout.session.require_login") unless logged_in?
  end
end
