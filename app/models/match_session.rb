require 'securerandom'

class MatchSession < ApplicationRecord
    before_create :generate_unique_tokens

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
