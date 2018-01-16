require 'test_helper'

class ExmoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get exmo_index_url
    assert_response :success
  end

end
