class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :require_user

protected

  def require_user
    current_user.present? || app_token_login || deny_access
  end
  
  def app_token_login
    User.find_by_app_token!(params[:app_token]) if params[:app_token]
  end

  def deny_access
    # store_location
    redirect_to login_path
  end

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
