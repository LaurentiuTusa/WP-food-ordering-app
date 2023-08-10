class OrdersController < ApplicationController
  def add_to_cart
    puts "========================"
    puts "params: #{params}"
    puts params[:product_id]
      # #user.cart_items << product_id
      # current_user.cart_items << product_id
      # puts "current_user.cart_items: #{current_user.cart_items}"
      # redirect_to root_path, notice: 'Product added to cart'
    #redirect to root_path but with the last selected filters
    redirect_to root_path, notice: 'Product added to cart'
  end
end
