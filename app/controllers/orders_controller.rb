class OrdersController < ApplicationController
  include OrdersHelper

  before_action :authenticate_user!, only: :add_to_cart

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: 'You need to log in to add products to the cart'
    end
  end

  def add_to_cart
    filter_params = {
      category: params[:category],
      vegetarian: params[:vegetarian],
      'price-sorting': params['price-sorting'],
      min_price: params[:min_price],
      max_price: params[:max_price]
    }

    # find the product
    product = Product.find(params[:product_id])
    # check if the user has an order with status "isCart" true
    order = Order.find_by(user_id: current_user.id, isCart: true)
    # if not, create a new order with status "isCart" true, user_id current_user.id and total null as it will be calculated later
    if order.nil?
      order = Order.create(user_id: current_user.id, isCart: true)
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
    rescue => e
      puts "Error creating OrderItem: #{e.message}"
    end
    # redirect to root_path but with the last selected filters
    redirect_to root_path(filter_params), notice: 'Product added to cart'
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
