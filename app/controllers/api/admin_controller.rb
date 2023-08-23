class Api::AdminController < ApplicationController
  include ActionController::HttpAuthentication::Token
  before_action :admin_user

  def view_profile
    @user = User.find(params[:id])
    render json: @user, serializer: UserSerializer
  end

  def view_users
    @users = User.all
    render json: @users, each_serializer: UserSerializer
  end

  def destroy_user
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to view_users_path
  end

  def view_products
    @products = Product.includes(:category)
    render json: @products, each_serializer: ProductSerializer
  end

  def create_product
  end

  def edit_product
    @product = Product.find(params[:id])
  end

  def update_product
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = "Product updated"
      redirect_to view_products_path
    else
      render 'edit_product'
    end
  end

  def destroy_product
  end

  def view_orders
    @orders = Order.order(created_at: :desc).includes(:user)
    render json: @orders, each_serializer: OrderSerializer
  end

  def destroy_order
    order = Order.find(params[:id])
    order.destroy!
    flash[:success] = "Order deleted"
    redirect_to view_orders_path
  end

  def mark_order_as_handled
    order = Order.find(params[:id])
    order.handled!
    flash[:success] = "Order marked as handled"
    redirect_to view_orders_path
  end

  private

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def current_user
    token, _options = token_and_options(request)
    user_id = AuthenticationTokenService.decode(token)

    User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    head :unauthorized
  end

  def product_params
    params.require(:product).permit(:title, :description, :price, :vegetarian, :category_id)
  end
end
