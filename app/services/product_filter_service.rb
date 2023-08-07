class ProductFilterService
  def initialize(params)
    @params = params
  end

  def filter_products
    selected_category = @params[:category]
    selected_vegetarian = @params[:vegetarian]
    selected_price_order = @params['price-sorting']
    selected_min_price = @params[:min_price]
    selected_max_price = @params[:max_price]

    if selected_category != "All"
      products = Product.where(category: selected_category) if selected_category.present?
      products = products.where(vegetarian: selected_vegetarian) if selected_vegetarian.present?
    else
      products = Product.where(vegetarian: selected_vegetarian) if selected_vegetarian.present?
    end
    
    products = products.where(price: selected_min_price..selected_max_price) if selected_min_price.present? && selected_max_price.present?
    if selected_price_order.present?
      price_order = selected_price_order.to_sym
      products = products.order(price: price_order)
    end
    products
  end
end