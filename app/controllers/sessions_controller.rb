class SessionsController < ApplicationController 
    def new 
    end

    def create 
        user = User.find_by(email: params[:email]) 
        if user&.authenticate(params[:password]) 
        session[:user_id] = user.id 
        redirect_to root_path, notice: "Увійшли успішно!" 
        else 
        flash.now[:alert] = "Неправильний email або пароль" 
        render :new, status: :unprocessable_entity 
        end 
    end 

    def destroy 
        session[:user_id] = nil 
        redirect_to root_path, notice: "Ви вийшли із системи" 
    end 
end 