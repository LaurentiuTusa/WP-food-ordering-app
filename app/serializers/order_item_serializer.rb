class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :order_id, :product_id

  belongs_to :product
end
