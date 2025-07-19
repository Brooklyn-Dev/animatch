require "test_helper"

class MatchSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @match_session = match_sessions(:one)
  end

  test "should get index" do
    get match_sessions_url
    assert_response :success
  end

  test "should get new" do
    get new_match_session_url
    assert_response :success
  end

  test "should create match_session" do
    assert_difference("MatchSession.count") do
      post match_sessions_url, params: { match_session: { edit_token: @match_session.edit_token, recommendations: @match_session.recommendations, shared_anime: @match_session.shared_anime, username1: @match_session.username1, username2: @match_session.username2 } }
    end

    assert_redirected_to match_session_url(MatchSession.last)
  end

  test "should show match_session" do
    get match_session_url(@match_session)
    assert_response :success
  end

  test "should get edit" do
    get edit_match_session_url(@match_session)
    assert_response :success
  end

  test "should update match_session" do
    patch match_session_url(@match_session), params: { match_session: { edit_token: @match_session.edit_token, recommendations: @match_session.recommendations, shared_anime: @match_session.shared_anime, username1: @match_session.username1, username2: @match_session.username2 } }
    assert_redirected_to match_session_url(@match_session)
  end

  test "should destroy match_session" do
    assert_difference("MatchSession.count", -1) do
      delete match_session_url(@match_session)
    end

    assert_redirected_to match_sessions_url
  end
end
