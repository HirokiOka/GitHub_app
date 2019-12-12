require 'test_helper'

class JsCodesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get js_codes_new_url
    assert_response :success
  end

end
