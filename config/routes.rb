Rails.application.routes.draw do
  resources :match_sessions, only: [:new, :create, :show]
  
  get "/match_sessions/:id/edit/:edit_token", to: "match_sessions#edit", as: :edit_match_session
  patch "/match_sessions/:id/edit/:edit_token", to: "match_sessions#update", as: :update_match_session
  delete "/match_sessions/:id/edit/:edit_token", to: "match_sessions#destroy", as: :destroy_match_session

  get "up" => "rails/health#show", as: :rails_health_check
  # root "posts#index"
end
