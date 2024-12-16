class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in? 
  helper_method :admin_user?
 
  def current_user 
    @current_user ||= User.find_by(id: session[:user_id]) 
  end 
 
  def logged_in? 
    current_user.present? 
  end 

  def require_user 
    redirect_to login_path, alert: "Вам потрібно увійти" unless logged_in? 
  end 
  
  private

  def admin_user?
    current_user&.role == 'admin'
  end

  def authorize_admin
    unless admin_user?
      redirect_to root_path, alert: "Access not allowed!"
    end
  end
end
