require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  include SessionsHelper

  let!(:user) { User.find(1) }

  describe 'POST #add_to_cart' do
    context 'when user is not logged in' do
      it 'does not add a product to the cart' do
        expect {
          post :add_to_cart, params: { product_id: 1 }
        }.not_to change(OrderItem, :count)
      end
    end
  end
end
