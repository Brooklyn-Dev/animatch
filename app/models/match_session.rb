require 'securerandom'

class MatchSession < ApplicationRecord
    before_create :generate_edit_token

    private
        def generate_edit_token
            self.edit_token = SecureRandom.urlsafe_base64(16)
        end
end
