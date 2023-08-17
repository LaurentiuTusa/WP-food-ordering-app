class AdminController < ApplicationController
  before_action :admin_user

  def view_profile
    @user = User.find(params[:id])
  end

  def view_users
    @users = User.paginate(page: params[:page])
  end

  def destroy_user
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to view_users_path
  end

  def view_products
  end

  def destroy_product
  end

  def view_orders
    @orders = Order.order(created_at: :desc).paginate(page: params[:page])
  end

  def destroy_order
    order = Order.find(params[:id])
    order.destroy
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

end
