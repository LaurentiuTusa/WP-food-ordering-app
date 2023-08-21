require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include SessionsHelper

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        name: 'John Doe',
        email: generate_unique_email('johndoe@yahoo.com'),
        password: 'password123',
        password_confirmation: 'password123'
      }
    end

    subject { post :create, params: { user: valid_attributes } }

    context 'with valid attributes' do
      it 'creates a new user' do
        expect { subject }.to change(User, :count).by(1)
        user = assigns(:user)
        session[:user_id] = user.id
        expect(logged_in?).to be(true)
      end

      it 'sends email activation to the user' do
        expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'logs in the user after it activates their account via email' do
        post :create, params: { user: valid_attributes }
        expect(logged_in?).to be(false)
        user = assigns(:user)
        get :edit, params: { id: user.activation_token, email: user.email, controller: 'account_activations' }
        expect(logged_in?).to be(true)
      end

      it 'redirects to the user show page' do
        subject
        user = assigns(:user)
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with invalid attributes' do

      before { valid_attributes.merge!(email: 'john@example.com') }

      it 'does not create a new user with the same email' do
        expect { subject }.not_to change(User, :count)
      end

      before { valid_attributes.merge!(email: 'invalid_email', password: 'short', name: '') }

      it 'does not create a new user' do
        expect { subject }.not_to change(User, :count)
      end

      it 're-renders the :new template' do
        expect { subject }.to render_template(:new)
      end
    end
  end

  let (:user) { User.find_by(name: "Michael Example") }
  let (:other_user) { User.find_by(name: "Malory Archer") }
  
  describe '#correct_user' do
    it 'redirects to root_url if current user is not the correct user' do
      log_in(user)
      get :edit, params: { id: other_user.id }

      expect(response).to redirect_to(root_url)
    end

    it 'does not redirect if current user is the correct user' do
      log_in(user)
      get :edit, params: { id: user.id }

      expect(response).not_to redirect_to(root_url)
    end
  end
end
