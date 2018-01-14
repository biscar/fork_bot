require 'test_helper'

class ForkControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fork_index_url
    assert_response :success
  end

end
