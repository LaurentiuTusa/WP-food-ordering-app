require 'product_filter_service'

class HomeController < ApplicationController
  def index
    @products = Product.all
  end 
  
  def apply_filters
    product_filter_service = ProductFilterService.new(params)
    @products = product_filter_service.filter_products
    render :index
  end
end
