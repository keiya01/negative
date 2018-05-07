require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get agreement" do
    get home_agreement_url
    assert_response :success
  end

end
