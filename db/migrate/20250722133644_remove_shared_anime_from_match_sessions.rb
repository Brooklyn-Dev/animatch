class RemoveSharedAnimeFromMatchSessions < ActiveRecord::Migration[8.0]
  def change
    remove_column :match_sessions, :shared_anime, :jsonb
  end
end
