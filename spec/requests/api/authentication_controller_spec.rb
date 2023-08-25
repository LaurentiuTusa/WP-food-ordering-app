require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  let!(:user) { User.where(admin: true).first }

  describe 'POST /api/login' do
    context 'when the user logs in with correct credentials' do
      before { post '/api/login', params: { email: user.email, password: 'qwerty' } }

      it 'returns status ok and creates the token' do
        expect(response).to have_http_status(:ok)
        expect(json['token']).to eq(AuthenticationTokenService.encode(user.id))
      end
    end

    context 'when the user logs in with incorrect credentials' do
      before { post '/api/login', params: { email: user.email, password: 'invalid' } }

      it 'returns status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
