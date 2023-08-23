class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :is_cart, :status, :user_id

  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
end
