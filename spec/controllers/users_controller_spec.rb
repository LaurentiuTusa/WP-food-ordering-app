require 'rails_helper'

def generate_unique_email(base_email)
  random_string = SecureRandom.hex(4) # Generate a random string of length 8
  domain = base_email.split('@').last
  modified_email = "#{base_email.gsub('@' + domain, '')}+#{random_string}@#{domain}"
  modified_email.downcase
end

RSpec.describe UsersController, type: :controller do
  include SessionsHelper

  let(:valid_attributes) do
    {
      name: 'John Doe',
      email: generate_unique_email('johndoe@yahoo.com'),
      password: 'password123',
      password_confirmation: 'password123'
    }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'does not create a new user with the same email' do
        expect {
          post :create, params: { user: valid_attributes.merge(email: 'john@example.com') }
        }.not_to change(User, :count)
      end

      it 'logs in the user' do
        post :create, params: { user: valid_attributes }
        expect(logged_in?).to be(true)
      end

      it 'sets a success flash message' do
        post :create, params: { user: valid_attributes }
        expect(flash[:success]).to eq("Welcome to the Sample App!")
      end

      it 'redirects to the user show page' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(assigns(:user))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: { name: '', email: 'invalid_email', password: 'short' } }
        }.not_to change(User, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { user: { name: '', email: 'invalid_email', password: 'short' } }
        expect(response).to render_template(:new)
      end
    end
  end

  let (:user) { User.find(1) }
  let (:other_user) { User.find(2) }
  
  describe '#correct_user' do
    it 'redirects to root_url if current user is not the correct user' do
      log_in(user)  # Assuming you have a log_in helper method
      get :edit, params: { id: other_user.id }  # Replace with the actual action and parameters

      expect(response).to redirect_to(root_url)
    end

    it 'does not redirect if current user is the correct user' do
      log_in(user)
      get :edit, params: { id: user.id }

      expect(response).not_to redirect_to(root_url)
    end
  end
end
