require 'product_filter_service'

class HomeController < ApplicationController
  def index
    @products = Product.all
    @filter_params = {}

    @filter_params[:category] = params[:category]
    @filter_params[:vegetarian] = params[:vegetarian]
    @filter_params['price-sorting'] = params['price-sorting']
    @filter_params[:min_price] = params[:min_price]
    @filter_params[:max_price] = params[:max_price]
  end 
  
  def apply_filters
    product_filter_service = ProductFilterService.new(params)
    @products = product_filter_service.filter_products
    render :index
  end
end
