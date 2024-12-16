class CartsController < ApplicationController
  before_action :require_user
  before_action :set_cart, only: %i[ show edit update destroy ]

  # GET /carts or /carts.json
  def index
    @user ||= User.find_by(id: session[:user_id]) 
    @carts = Cart.where(user_id: @user.id)
  end

  # GET /carts/1 or /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts or /carts.json
  def create
    @user ||= User.find_by(id: session[:user_id]) 
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: "Cart was successfully created." }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    @user ||= User.find_by(id: session[:user_id]) 
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: "Cart was successfully updated." }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @user ||= User.find_by(id: session[:user_id]) 
    @cart.destroy!

    respond_to do |format|
      format.html { redirect_to carts_path, status: :see_other, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_to_cart
    @user = User.find_by(id: session[:user_id]) 
    product = Product.find(params[:product_id])

    @cart = Cart.find_or_initialize_by(user_id: @user.id, product_id: product.id)
    @cart.quantity ||= 0
    @cart.quantity += 1

    if @cart.save
      redirect_to carts_path, notice: 'Product added to cart!'
    else
      redirect_to products_path, alert: 'Error adding product to cart'
    end
  end
 

  def checkout 
    @user = User.find_by(id: session[:user_id]) 
    @cart_items = Cart.where(user_id: @user.id)
 
    if @cart_items.empty? 
      redirect_to carts_path, alert: 'Ваш кошик порожній!' 
      return 
    end 

    @cart_items.each do |cart_item| 
      if cart_item.product.stock < cart_item.quantity 
        redirect_to carts_path, alert: "Недостатньо товарів для #{cart_item.product.name}."  
        return 
      end 
    end 

    # Створення замовлення 
    @order = Order.create!( 
      user: @user, 
      address: params[:address], 
      order_date: Time.now 
    ) 

 

    @cart_items.each do |cart_item| 
      @order.order_items.create!( 
        product: cart_item.product, 
        quantity: cart_item.quantity 
      ) 

      # Оновлення запасів товару 
      cart_item.product.update!(stock: cart_item.product.stock - cart_item.quantity) 
    end 

    # Очищення кошика 
    Cart.where(user_id: @user.id).destroy_all
    redirect_to orders_path, notice: 'Замовлення успішно оформлено!' 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find_by_id(params[:id]) || @cart = Cart.create(params[:cart])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.require(:cart).permit(:user_id, :product_id, :quanitity)
    end
end
