class CreateMatchSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :match_sessions do |t|
      t.string :username1
      t.string :username2
      t.string :edit_token
      t.text :shared_anime
      t.text :recommendations

      t.timestamps
    end
  end
end
