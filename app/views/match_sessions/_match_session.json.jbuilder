json.extract! match_session, :id, :username1, :username2, :edit_token, :shared_anime, :recommendations, :created_at, :updated_at
json.url match_session_url(match_session, format: :json)
