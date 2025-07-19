require "test_helper"

class MatchSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @match_session = match_sessions(:one)
  end

  test "should get new" do
    get new_match_session_url
    assert_response :success
  end

  test "should create match_session" do
    assert_difference("MatchSession.count") do
      post create_match_session_url, params: { match_session: { username1: @match_session.username1, username2: @match_session.username2 } }
    end

    assert_redirected_to edit_match_session_url(MatchSession.last.edit_token)
  end

  test "should show match_session" do
    get public_match_session_url(@match_session.public_token)
    assert_response :success
  end

  test "should get edit" do
    get edit_match_session_url(@match_session.edit_token)
    assert_response :success
  end

  test "should update match_session" do
    patch update_match_session_url(@match_session.edit_token), params: { match_session: { username1: "updated_user" } }
    assert_redirected_to edit_match_session_url(@match_session.edit_token)
  end

  test "should destroy match_session" do
    assert_difference("MatchSession.count", -1) do
      delete destroy_match_session_url(@match_session.edit_token)
    end

    assert_redirected_to new_match_session_url
  end
end
