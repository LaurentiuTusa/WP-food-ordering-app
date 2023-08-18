class OrdersController < ApplicationController
  include OrdersHelper

  before_action :authenticate_user!, only: :add_to_cart

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: 'You need to log in to add products to the cart'
    end
  end

  def add_to_cart
    filter_params = params.permit(:category, :vegetarian, :'price-sorting', :min_price, :max_price)

    # find the product
    product = Product.find(params[:product_id])
    # check if the user has an order with status "isCart" true, or create a new one otherwise
    order = Order.find_or_create_by(user_id: current_user.id, isCart: true) do |new_order|
      new_order.status = 0
    end
    # create a new order_item with the order_id of the order created above and the product_id of the product found above
    begin
      # first search if the product is already in the cart. if it is, then just increase its quantity
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
    # redirect to root_path but with the last selected filters
    redirect_to root_path(filter_params), notice: 'Product added to cart'
  end

  def view_cart
    # find the order with status "isCart" true and user_id current_user.id
    @order = Order.find_by(user_id: current_user.id, isCart: true)
    # if the order is nil, then redirect to root_path
    if @order.nil?
      redirect_to root_path, alert: 'Cart is empty'
    else
      # find all the order_items with order_id the id of the order found above
      @order_items = OrderItem.where(order_id: @order.id).paginate(page: params[:page])
      # if the order_items are empty, then redirect to root_path
      if @order_items.empty?
        redirect_to root_path, alert: 'Cart has been emptied'
      end
    end
  end

  def remove_product_from_cart
    # Find the order item to remove
    order_item = OrderItem.find(params[:order_item_id])

    # Decrement the quantity if it's greater than 1, otherwise destroy the order item
    if order_item.quantity > 1
      order_item.decrement!(:quantity)
    else
      order_item.destroy
    end

    redirect_to view_cart_path, notice: 'Product removed from cart'
  end

  def convert_cart_to_order
    # get the products form the cart
    @order_products = get_cart_products
    # get the order from the cart
    @order = Order.find_by(user_id: current_user.id, isCart: true)
    # set the status of the order to "isCart" false
    @order.isCart = false
    # set the total of the order to the sum of the prices of the products in the cart
    @order.total = @order_products.sum { |product| product.price }
    # save the order
    @order.save
    # redirect to root_path but with the last selected filters
    redirect_to root_path, notice: 'Order created'
  end
end
