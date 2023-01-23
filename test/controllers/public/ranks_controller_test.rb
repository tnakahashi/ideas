require "test_helper"

class Public::RanksControllerTest < ActionDispatch::IntegrationTest
  test "should get rank" do
    get public_ranks_rank_url
    assert_response :success
  end
end
