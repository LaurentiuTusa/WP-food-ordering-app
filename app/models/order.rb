class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
  enum status: { unhandled: 0, handled: 1 }

  validate :one_cart_order_per_user, on: :create, if: :isCart

  before_save :update_cart_status_for_user, if: :isCart

  private

  def one_cart_order_per_user
    errors.add(:base, "User already has a cart order") if user.orders.exists?(isCart: true)
  end

  def update_cart_status_for_user
    user.orders.where(isCart: true).update_all(isCart: false)
  end
end
