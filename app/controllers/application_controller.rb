class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :require_user

protected

  def require_user
    current_user.present? || deny_access
  end

  def deny_access
    # store_location
    redirect_to login_path
  end

private

  def current_user
    @current_user ||= if session[:user_id]
      User.find(session[:user_id])
    elsif params[:app_token]
      User.find_by_app_token!(params[:app_token])
    end
  end
end
