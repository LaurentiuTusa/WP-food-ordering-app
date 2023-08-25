class Api::OrdersController < Api::ApplicationController
  include OrdersHelper
  before_action :authenticate_user!, only: [:add_to_cart, :view_cart, :convert_cart_to_order]

  def add_to_cart
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

      render json: { error: "Error creating OrderItem: #{e.message}" }, status: :unprocessable_entity
    end

    render json: order, serializer: OrderSerializer, status: :ok
  end

  def view_cart
    @order = Order.find_by(user_id: current_user.id, isCart: true)
    if @order.nil?

      render json: { error: 'Cart is empty' }, status: :unprocessable_entity
    else
      @order_items = OrderItem.includes(:product).where(order_id: @order.id)

      render json: { error: 'Cart is empty' }, status: :unprocessable_entity if @order_items.empty?

      render json: @order_items, each_serializer: OrderItemSerializer
    end
  end

  def remove_product_from_cart
    order_item = OrderItem.find(params[:order_item_id])
    if order_item.quantity > 1
      order_item.decrement!(:quantity)
    else
      order_item.destroy
    end

    render json: { success: 'Product removed from cart' }, status: :ok
  end

  def convert_cart_to_order
    @order_products = get_cart_products
    @order = Order.find_by(user_id: current_user.id, isCart: true)
    @order.isCart = false
    @order.total = @order_products.sum { |product| product.price }
    if @order.save

      render json: @order, serializer: OrderSerializer, status: :ok
    else

      render json: { error: 'Unable to convert cart to order' }, status: :unprocessable_entity
    end
  end
end
