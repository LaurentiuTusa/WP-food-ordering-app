module OrdersHelper
  def get_cart_products
    @order = Order.find_by(user_id: current_user.id, isCart: true)
    @order_items = OrderItem.where(order_id: @order.id)
    @pruducts_from_cart = []

    @order_items.each do |order_item|
      order_item.quantity.times do
        @pruducts_from_cart << Product.find(order_item.product_id)
      end
    end
    @pruducts_from_cart
  end
end
