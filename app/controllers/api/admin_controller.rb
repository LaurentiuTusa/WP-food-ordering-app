class Api::AdminController < Api::ApplicationController
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
    user = User.find(params[:id])

    if user.destroy

      render json: { success: 'User deleted' }, status: :ok
      return
    end

    render json: { error: 'Error deleting user' }, status: :unprocessable_entity
  end

  def view_products
    @products = Product.includes(:category)

    render json: @products, each_serializer: ProductSerializer
  end

  def create_product
  end

  def edit_product
    @product = Product.find(params[:id])

    render json: @product, serializer: ProductSerializer
  end

  def update_product
    @product = Product.find(params[:id])
    if @product.update(product_params)

      render json: @product, serializer: ProductSerializer, status: :ok
    else

      render json: @product.errors, status: :unprocessable_entity
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
    render json: { success: 'Order deleted' }, status: :ok
  end

  def mark_order_as_handled
    order = Order.find(params[:id])
    if order.nil?

      render json: { error: 'Order not found' }, status: :not_found
      return
    end
    order.handled!

    render json: order, serializer: OrderSerializer, status: :ok
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :vegetarian, :category_id)
  end

  # Confirms an admin user.
  def admin_user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_authorized_user.admin?
  end
end
