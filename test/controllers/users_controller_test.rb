require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_path
    assert_response :success
    assert_select '.navbar-brand', 'SnippetMan'
  end

  test "should have an authentication button if not authenticated" do
    get '/logout'
    assert_redirected_to action: "index"
    follow_redirect!
    assert_response :success
    assert_select '.btn.btn-info', 'Authenticate with Github'
  end
end
