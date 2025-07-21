class MatchSessionsController < ApplicationController
  before_action :set_match_session_by_edit_token, only: [ :edit, :update, :destroy ]
  before_action :set_match_session_by_public_token, only: [ :show ]

  def show
    @match_session = MatchSession.find_by!(public_token: params[:public_token])
    @recommendations_with_data = @match_session.fetch_recommendations_with_data
  end

  def new
    @match_session = MatchSession.new
  end

  def edit
  end

  def create
    @match_session = MatchSession.new(match_session_params)
    @match_session.recommendations = fetch_anime_and_generate_recommendations.to_json

    respond_to do |format|
      if @match_session.save
        format.html { redirect_to edit_match_session_path(@match_session.edit_token), notice: "Match session was successfully created." }
        format.json { render :show, status: :created, location: @match_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match_session.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    new_recommendations = fetch_anime_and_generate_recommendations.to_json

    respond_to do |format|
      if @match_session.update(match_session_params.merge(recommendations: new_recommendations))
        format.html { redirect_to edit_match_session_path(@match_session.edit_token), notice: "Match session was successfully updated." }
        format.json { render :show, status: :ok, location: @match_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match_session.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @match_session.destroy

    respond_to do |format|
      format.html { redirect_to new_match_session_path, status: :see_other, notice: "Match session was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    def set_match_session_by_public_token
      @match_session = MatchSession.find_by!(public_token: params[:public_token])
    end

    def set_match_session_by_edit_token
      @match_session = MatchSession.find_by!(edit_token: params[:edit_token])
    end

    def match_session_params
      params.expect(match_session: [ :username1, :username2 ])
    end

    MIN_SHARED_SCORE = 7.0
    MAX_GENRES = 5
    GENRE_MATCH_WEIGHT = 10
    LONG_ANIME_THRESHOLD = 50
    LONG_ANIME_PENALTY = 5
    RECOMMENDATION_LIMIT = 20

    def fetch_anime_and_generate_recommendations
      u1_anime = AnilistService.get_user_completed_anime(@match_session.username1)
      u2_anime = AnilistService.get_user_completed_anime(@match_session.username2)

      u1_map = u1_anime.index_by { |entry| entry.dig("media", "id") }
      u2_map = u2_anime.index_by { |entry| entry.dig("media", "id") }

      shared_ids = u1_map.keys & u2_map.keys

      # Filter by user score
      shared_anime = shared_ids.map do |id|
        u1_score = u1_map[id]["score"]
        u2_score = u2_map[id]["score"]

        if u1_score >= MIN_SHARED_SCORE && u2_score >= MIN_SHARED_SCORE
          {
            id: id,
            score1: u1_score,
            score2: u2_score,
            genres: u1_map[id]["media"]["genres"],
            media: u1_map[id]["media"]
          }
        end
      end.compact

      # Get most frequent genres
      genre_freq = Hash.new(0)
      shared_anime.each do |anime|
        anime[:genres].each { |genre| genre_freq[genre] += 1 }
      end
      top_genres = genre_freq.sort_by { |_g, count| -count }.map(&:first).take(MAX_GENRES)

      # Get top unseen anime
      top_anime = AnilistService.get_top_anime()
      completed_ids = u1_map.keys | u2_map.keys
      unseen_candidates = top_anime.reject { |anime| completed_ids.include?(anime["id"]) }

      # Score recommendations
      scored_recommendations = unseen_candidates.map do |anime|
        overlap = (anime["genres"] & top_genres).size
        score = overlap * GENRE_MATCH_WEIGHT + (anime["averageScore"] || 0)
        score -= LONG_ANIME_PENALTY if anime["episodes"] && anime["episodes"] > LONG_ANIME_THRESHOLD

        { id: anime["id"], match_score: score }
      end

      scored_recommendations.sort_by! { |rec| -rec[:match_score] }
      scored_recommendations.take(RECOMMENDATION_LIMIT)
    end
end
