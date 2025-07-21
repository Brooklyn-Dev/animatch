class ChangeRecommendationsToJsonb < ActiveRecord::Migration[8.0]
  def change
    change_column :match_sessions, :recommendations, :jsonb, using: 'recommendations::jsonb'
    change_column :match_sessions, :shared_anime, :jsonb, using: 'shared_anime::jsonb'
  end
end
