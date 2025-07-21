require "securerandom"

class MatchSession < ApplicationRecord
    before_create :generate_unique_tokens

    def parsed_recommendations
        JSON.parse(recommendations || "[]", symbolize_names: true)
    end

    def fetch_recommendations_with_data
        ids = parsed_recommendations.map { |rec| rec[:id] }
        [] if ids.empty?

        anime_data = AnilistService.get_anime_by_ids(ids)

        parsed_recommendations.map do |rec|
            anime = anime_data.find { |a|  a["id"] == rec[:id] }
            next unless anime

            anime
        end.compact
    end

    private
        def generate_unique_tokens
            begin
                self.public_token = SecureRandom.urlsafe_base64(12)
            end while self.class.exists?(public_token: public_token)

            begin
                self.edit_token = SecureRandom.urlsafe_base64(16)
            end while self.class.exists?(edit_token: edit_token)
        end
end
