require "test_helper"

class Public::DraftsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_drafts_index_url
    assert_response :success
  end

  test "should get edit" do
    get public_drafts_edit_url
    assert_response :success
  end
end
