require "application_system_test_case"

class MatchSessionsTest < ApplicationSystemTestCase
  setup do
    @match_session = match_sessions(:one)
  end

  test "visiting the index" do
    visit match_sessions_url
    assert_selector "h1", text: "Match sessions"
  end

  test "should create match session" do
    visit match_sessions_url
    click_on "New match session"

    fill_in "Edit token", with: @match_session.edit_token
    fill_in "Recommendations", with: @match_session.recommendations
    fill_in "Shared anime", with: @match_session.shared_anime
    fill_in "Username1", with: @match_session.username1
    fill_in "Username2", with: @match_session.username2
    click_on "Create Match session"

    assert_text "Match session was successfully created"
    click_on "Back"
  end

  test "should update Match session" do
    visit match_session_url(@match_session)
    click_on "Edit this match session", match: :first

    fill_in "Edit token", with: @match_session.edit_token
    fill_in "Recommendations", with: @match_session.recommendations
    fill_in "Shared anime", with: @match_session.shared_anime
    fill_in "Username1", with: @match_session.username1
    fill_in "Username2", with: @match_session.username2
    click_on "Update Match session"

    assert_text "Match session was successfully updated"
    click_on "Back"
  end

  test "should destroy Match session" do
    visit match_session_url(@match_session)
    click_on "Destroy this match session", match: :first

    assert_text "Match session was successfully destroyed"
  end
end
