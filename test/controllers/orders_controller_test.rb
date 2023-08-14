require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get add_to_cart" do
    get orders_add_to_cart_url
    assert_response :success
  end
end
