class Admin::DashboardController < ApplicationController

  before_action :require_admin

  def index
    @products = Product.all
  end

  private

  def require_admin
    unless current_user&.role == 'admin'
      redirect_to root_path, alert: 'No access!'
    end
  end
end
