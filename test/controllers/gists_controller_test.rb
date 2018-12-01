require 'test_helper'

class GistsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to home if not authenticated" do
    get '/logout'
    get gists_url
    assert_redirected_to root_path
  end
end
