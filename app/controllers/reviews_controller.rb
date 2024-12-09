class ReviewsController < ApplicationController
    before_action :require_user
    before_action :set_product 

    def create 
        @review = @product.reviews.build(review_params) 
        @review.user = current_user 
        if @review.save 
            redirect_to product_path(@product), notice: 'Відгук додано.' 
        else 
            redirect_to product_path(@product), alert: 'Помилка при додаванні відгуку.' 
        end 
    end 

    private 
    def set_product 
        @product = Product.find(params[:product_id]) 
    end 

    def review_params 
        params.require(:review).permit(:content, :rating) 
    end 
end