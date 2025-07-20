class MatchSessionsController < ApplicationController
  before_action :set_match_session_by_edit_token, only: [ :edit, :update, :destroy ]
  before_action :set_match_session_by_public_token, only: [ :show ]

  def show
  end

  def new
    @match_session = MatchSession.new
  end

  def edit
  end

  def create
    @match_session = MatchSession.new(match_session_params)

    respond_to do |format|
      if @match_session.save
        fetch_anime_and_generate_recommendations

        format.html { redirect_to edit_match_session_path(@match_session.edit_token), notice: "Match session was successfully created." }
        format.json { render :show, status: :created, location: @match_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match_session.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @match_session.update(match_session_params)
        fetch_anime_and_generate_recommendations

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
      format.html { redirect_to new_match_session_path, status: :see_other, notice: "Match session was successfully destroyed." }
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

    def fetch_anime_and_generate_recommendations
        user1_anime = AnilistService.get_user_completed_anime(@match_session.username1)
        user2_anime = AnilistService.get_user_completed_anime(@match_session.username2)

        # TODO: Generate recommendations using shared anime
    end
end
