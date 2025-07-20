require "net/http"
require "uri"
require "json"

class AnilistService
  API_URL = "https://graphql.anilist.co/".freeze

  def self.make_request(query, variables = {})
    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Accept"] = "application/json"
    request.body = {
      query: query,
      variables: variables
    }.to_json

    response = http.request(request)

    if response.code == "200"
      JSON.parse(response.body)
    else
      Rails.logger.error "AniList API Error: #{response.code} - #{response.body}"
      nil
    end
  end

  def self.get_user_completed_anime(username, page = 1, per_page = 50)
    all_anime = []

    loop do
      query = <<~GRAPHQL
        query ($username: String, $page: Int, $perPage: Int) {
          Page(page: $page, perPage: $perPage) {
              pageInfo {
                hasNextPage
              }
              mediaList(userName: $username, type: ANIME, status: COMPLETED) {
                score
                media {
                  id
                  genres
                  averageScore
                  popularity
                  format
                }
            }
          }
        }
        GRAPHQL

      variables = {
        username: username,
        page: page,
        perPage: per_page
      }

      result = make_request(query, variables)
      break unless result

      media_list = result.dig("data", "Page", "mediaList") || []
      break if media_list.empty?

      all_anime.concat(media_list)

      page_info = result.dig("data", "Page", "pageInfo") || {}
      break unless page_info["hasNextPage"]

      page += 1
      sleep(0.1)
    end

    all_anime
  end
end
