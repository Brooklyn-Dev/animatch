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

      variables = { username: username, page: page, perPage: per_page }

      result = make_request(query, variables)
      break unless result

      media_list = result.dig("data", "Page", "mediaList") || []
      break if media_list.empty?

      all_anime.concat(media_list)
      break if !result.dig("data", "Page", "pageInfo", "hasNextPage")

      page += 1
      sleep(0.1)
    end

    all_anime
  end

  def self.get_top_anime(page = 1, per_page = 50, limit = 500)
    all_anime = []

    while all_anime.size < limit
      query = <<~GRAPHQL
        query ($page: Int, $perPage: Int) {
          Page(page: $page, perPage: $perPage) {
              pageInfo {
                hasNextPage
              }
              media(type: ANIME, sort: [SCORE_DESC]) {
                id
                title {
                  romaji
                  english
                }
                coverImage {
                  medium
                }
                genres
                averageScore
                popularity
                episodes
                format
            }
          }
        }
      GRAPHQL

      variables = { page: page, perPage: per_page }

      result = make_request(query, variables)
      break unless result

      media = result.dig("data", "Page", "media") || []
      break if media.empty?

      all_anime.concat(media)
      break if !result.dig("data", "Page", "pageInfo", "hasNextPage")

      page += 1
      sleep(0.1)
    end

    all_anime.take(limit)
  end

  def self.get_anime_by_ids(ids)
    return [] if ids.empty?

    query = <<~GRAPHQL
      query ($ids: [Int]) {
        Page(perPage: #{ids.size}) {
          media(id_in: $ids, type: ANIME) {
            id
            title {
              romaji
              english
            }
          }
        }
      }
    GRAPHQL

    variables = { ids: ids }

    result = make_request(query, variables)
    return [] unless result && result["data"]

    result.dig("data", "Page", "media") || []
  end

  def self.user_exists?(username)
    query = <<~GRAPHQL
      query ($name: String) {
        User(name: $name) {
          id
        }
      }
    GRAPHQL

    variables = { name: username }

    result = make_request(query, variables)
    false unless result.is_a?(Hash)

    result.dig("data", "User").present?
  rescue => e
    Rails.logger.error("AniList user check failed for #{username}: #{e.message}")
    false
  end
end
