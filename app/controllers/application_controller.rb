class ApplicationController < ActionController::Base
  around_action :tag_logs_with_user_id
  around_action :set_time_zone, if: :current_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_controller?, :logged_in?


  def current_controller?(names)
    names.include?(controller_name)
  end

  def require_subscription!
    redirect_to '/subscription/new' unless subscribed?
  end

  def require_login!
    redirect_to '/welcome' unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  def subscribed?
    logged_in? && current_user.subscribed?
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:token])
  end

  def login(user)
    session[:token] = user.session_token
  end

  def logout
    current_user.try(:reset_session_token!)
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def tag_logs_with_user_id
    tag = "user-anonymous"
    if logged_in?
      tag = "user-#{ current_user.id } #{ current_user.email }"
    end
    Rails.logger.tagged(tag) do
      yield
    end
  end
end
