class AddPublicTokenToMatchSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :match_sessions, :public_token, :string
    add_index :match_sessions, :public_token, unique: true
    add_index :match_sessions, :edit_token, unique: true
  end
end
