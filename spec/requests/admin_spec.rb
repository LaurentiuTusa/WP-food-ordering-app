require 'rails_helper'

RSpec.describe "Admins", type: :request do
  describe "GET /view_orders" do
    it "returns http success" do
      get "/admin/view_orders"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy_order" do
    it "returns http success" do
      get "/admin/destroy_order"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /mark_order_as_handled" do
    it "returns http success" do
      get "/admin/mark_order_as_handled"
      expect(response).to have_http_status(:success)
    end
  end

end
