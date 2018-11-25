require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_path
    assert_response :success
    assert_select '.navbar-brand', 'SnippetMan'
  end
end
