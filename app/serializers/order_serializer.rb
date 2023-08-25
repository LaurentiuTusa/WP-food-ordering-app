class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :isCart, :status, :user_id

  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
end
