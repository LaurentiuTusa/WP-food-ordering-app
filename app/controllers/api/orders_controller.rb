class Api::OrdersController < ApplicationController
  include OrdersHelper

  before_action :authenticate_user!, only: :add_to_cart

  def authenticate_user!
    redirect_to login_path, alert: 'You need to log in to add products to the cart' if current_user.nil?
  end

  def add_to_cart
    filter_params = params.permit(:category, :vegetarian, :'price-sorting', :min_price, :max_price)

    product = Product.find(params[:product_id])
    order = Order.find_or_create_by(user_id: current_user.id, isCart: true) do |new_order|
      new_order.status = 0
    end

    begin
      order_item = OrderItem.find_by(order_id: order.id, product_id: product.id)
      if order_item.nil?
        OrderItem.create(order_id: order.id, product_id: product.id, quantity: 1)
      else
        order_item.quantity += 1
        order_item.save
      end
    rescue StandardError => e
      puts "Error creating OrderItem: #{e.message}"
    end

    redirect_to root_path(filter_params), notice: 'Product added to cart'
  end

  def view_cart
    @order = Order.find_by(user_id: current_user.id, isCart: true)
    if @order.nil?
      redirect_to root_path, alert: 'Cart is empty'
    else
      @order_items = OrderItem.includes(:product).where(order_id: @order.id).paginate(page: params[:page])
      redirect_to root_path, alert: 'Cart has been emptied' if @order_items.empty?
    end
  end

  def remove_product_from_cart
    order_item = OrderItem.find(params[:order_item_id])
    if order_item.quantity > 1
      order_item.decrement!(:quantity)
    else
      order_item.destroy
    end

    redirect_to view_cart_path, notice: 'Product removed from cart'
  end

  def convert_cart_to_order
    @order_products = get_cart_products
    @order = Order.find_by(user_id: current_user.id, isCart: true)
    @order.isCart = false
    @order.total = @order_products.sum { |product| product.price }
    @order.save
    redirect_to root_path, notice: 'Order created'
  end
end
