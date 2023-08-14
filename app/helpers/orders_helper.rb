module OrdersHelper
  def get_cart_products
    # find the order with status "isCart" true and user_id current_user.id
    @order = Order.find_by(user_id: current_user.id, isCart: true)
    # find all the order_items with order_id the id of the order found above
    @order_items = OrderItem.where(order_id: @order.id)
    @pruducts_from_cart = []
    # for each order_item found above, find the product with id the product_id of the order_item
    @order_items.each do |order_item|
      # if the found product has quanity > 1, then add it to the array @pruducts_from_cart as many times as its quantity
      order_item.quantity.times do
        @pruducts_from_cart << Product.find(order_item.product_id)
      end
    end
    @pruducts_from_cart
  end
end
