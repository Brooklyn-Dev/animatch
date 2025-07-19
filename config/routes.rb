Rails.application.routes.draw do
  get "/m/:public_token", to: "match_sessions#show", as: :public_match_session
  get "/e/:edit_token", to: "match_sessions#edit", as: :edit_match_session
  patch "/e/:edit_token", to: "match_sessions#update", as: :update_match_session
  delete "/e/:edit_token", to: "match_sessions#destroy", as: :destroy_match_session

  get "/new", to: "match_sessions#new", as: :new_match_session
  post "/match_sessions", to: "match_sessions#create", as: :create_match_session
end
