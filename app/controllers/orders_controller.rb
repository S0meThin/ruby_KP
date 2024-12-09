class OrdersController < ApplicationController
    before_action :require_user 
    def index 

        @user = User.find_by(id: session[:user_id]) 

        @orders = Order.where(user_id: @user.id)

    end 

    

    def show 

        @order = Order.find(params[:id]) 

        unless @order.user_id == session[:user_id] 

        redirect_to orders_path, alert: 'У вас немає доступу до цього замовлення.' 

        end 

    end 
end
