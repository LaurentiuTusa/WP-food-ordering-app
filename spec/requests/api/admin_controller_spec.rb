require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  let!(:user) { User.where(admin: true).first }
  let!(:token) { AuthenticationTokenService.encode(user.id) }
  let!(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/admin/users' do
    subject { get '/api/admin/view_users', headers: headers }

    context 'when there are users to display' do
      before { subject }

      it 'returns all users' do
        expect(response).to have_http_status(:success)
        parsed_json = json

        expect(parsed_json.size).to eq(User.count)
        expect(parsed_json).to all(include('id', 'name', 'email'))
      end
    end

    context 'when the user is not an admin' do
      let!(:user) { User.where(admin: false).first }

      before { subject }

      it 'returns an error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/admin/view_products' do
    subject { get '/api/admin/view_products', headers: headers }

    context 'when there are products to display' do
      before do
        create_list(:product, 5)
        subject
      end

      it 'returns all products' do
        expect(response).to have_http_status(:success)
        parsed_json = json

        expect(parsed_json.size).to eq(Product.count)
        expect(parsed_json).to all(include('id', 'title', 'description', 'price', 'vegetarian'))
      end
    end

    context 'when the user is not an admin' do
      let!(:user) { User.where(admin: false).first }

      before { subject }

      it 'returns an error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when there are NO products to display' do
      before do
        Product.destroy_all
        subject
      end

      it 'returns an empty array' do
        expect(response).to have_http_status(:success)
        parsed_json = json

        expect(parsed_json.size).to eq(0)
      end
    end
  end

  describe 'DELETE /api/admin/destroy_user/70' do
    subject { delete '/api/admin/destroy_user/70', headers: headers, params: { id: 70 } }

    context 'when the user is not an admin' do
      let!(:user) { User.where(admin: false).first }

      before { subject }

      it 'returns an error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when there exists the user to be deleted' do
      before do
        User.create(id: 70, name: 'UserToDelete', email: 'userdel@yahoo.com', password: 'password123', admin: false)
        subject
      end

      it 'deletes the user' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH api/admin/update_product/99' do
    subject { patch '/api/admin/update_product/99', headers: headers, params: { id: 99, product: { title: 'ProductUpdated', description: 'Description_updated', price: 10, vegetarian: false } } }

    context 'when there exists the product to be updated' do
      before do
        Product.create(id: 99, title: 'ProductToUpdate', description: 'ProductToUpdate_description', price: 10, vegetarian: false, category_id: 1)
        subject
      end

      it 'updates the product' do
        expect(response).to have_http_status(:ok)
        expect(json['title']).to eq('ProductUpdated')
        expect(json['description']).to eq('Description_updated')
      end
    end
  end
end
