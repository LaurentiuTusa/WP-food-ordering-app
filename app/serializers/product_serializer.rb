class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :vegetarian

  has_one :category
  has_one_attached :image

  # def image
  #   if object.image.attached?
  #     {
  #       url: rails_blob_url(object.image, only_path: true)
  #     }
  #   else
  #     nil
  #   end
  # end
end
