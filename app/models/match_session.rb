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

        def validate_usernames
          if username1.blank? || username2.blank?
            errors.add(:base, "Please enter two AniList usernames.")
          end

          if username1.present? && username2.present? && username1.downcase == username2.downcase
            errors.add(:base, "Usernames must be different.")
          end
        end
end
