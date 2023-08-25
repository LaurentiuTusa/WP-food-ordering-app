class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :vegetarian

  has_one :category
end
